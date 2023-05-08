


-------------------------------------------------- SELECT Functions ----------------------------------------------------------


--- 1 (To show the table of the tumors for each patient for the tumor chart)

CREATE OR REPLACE FUNCTION get_tumor_data(doctor_email TEXT, patient_id INTEGER)
RETURNS TABLE (
    submit_date TIMESTAMP WITHOUT TIME ZONE,
    cea_data FLOAT,
    ca19_data FLOAT,
    ca50_data FLOAT,
    ca24_data FLOAT,
    afp_data FLOAT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT tmp.t_submit_date AS submit_date,
        first_value(tmp.cea) OVER (PARTITION BY tmp.pnt_id, tmp.rp1 ORDER BY tmp.t_submit_date) AS cea_data,
        first_value(tmp.ca19) OVER (PARTITION BY tmp.pnt_id, tmp.rp2 ORDER BY tmp.t_submit_date) AS ca19_data,
        first_value(tmp.ca50) OVER (PARTITION BY tmp.pnt_id, tmp.rp3 ORDER BY tmp.t_submit_date) AS ca50_data,
        first_value(tmp.ca24) OVER (PARTITION BY tmp.pnt_id, tmp.rp4 ORDER BY tmp.t_submit_date) AS ca24_data,
        first_value(tmp.afp) OVER (PARTITION BY tmp.pnt_id, tmp.rp5 ORDER BY tmp.t_submit_date) AS afp_data
    FROM (
        SELECT t.pnt_id,
            t.t_submit_date,
            t.cea,
            t.ca19,
            t.ca50,
            t.ca24,
            t.afp,
            count(t.cea) OVER (PARTITION BY t.pnt_id ORDER BY t.t_submit_date) AS rp1,
            count(t.ca19) OVER (PARTITION BY t.pnt_id ORDER BY t.t_submit_date) AS rp2,
            count(t.ca50) OVER (PARTITION BY t.pnt_id ORDER BY t.t_submit_date) AS rp3,
            count(t.ca24) OVER (PARTITION BY t.pnt_id ORDER BY t.t_submit_date) AS rp4,
            count(t.afp) OVER (PARTITION BY t.pnt_id ORDER BY t.t_submit_date) AS rp5
        FROM doctor doc
        JOIN patients p ON doc.email = p.doc_email
        JOIN tumors t ON p.p_id = t.pnt_id
        WHERE doc.email = doctor_email AND t.pnt_id = patient_id
    ) tmp
    ORDER BY tmp.t_submit_date;
END;
$$ LANGUAGE plpgsql;

--- SELECT * from get_tumor_data('mohawaleeed2000@gmail.com', 1)




---- 2 (show patient data for the records)

CREATE OR REPLACE FUNCTION get_patient_data(
    p_id_input integer,
    dr_email_input text
)
RETURNS TABLE (
    p_id int,
    p_name text,
    age_years numeric(10,3),
    p_height integer,
    p_weight integer,
    p_gender boolean,
    p_smoke boolean,
    p_bsa numeric(10,3),
    p_submit_date date
)
AS $$
BEGIN
    RETURN QUERY SELECT 
        p.p_id,
        p.p_name,
        EXTRACT(YEAR FROM age(now(), p.p_bdate)) AS age_years,
        p.p_height,
        p.p_weight,
        p.p_gender,
        p.p_smoke,
        ROUND(p.p_bsa::numeric, 3) AS p_bsa,
        p.p_submit_date::date 
    FROM 
        patients p
        INNER JOIN doctor d ON p.doc_email = d.email
    WHERE 
        p.p_id = p_id_input
        AND d.email = dr_email_input;
END;
$$ LANGUAGE plpgsql;

--- SELECT * FROM get_patient_data(1, 'mohawaleeed2000@gmail.com');




--- 3 (select all patients of a doctor)

CREATE OR REPLACE FUNCTION get_all_patient_by_doctor_email(doc_email_input text)
  RETURNS TABLE (p_id integer, p_name text, p_submit_date timestamp without time zone) AS
$$
BEGIN
  RETURN QUERY
    SELECT p.p_id, p.p_name, p.p_submit_date
    FROM patients p
    JOIN doctor d ON d.email = p.doc_email
    WHERE p.doc_email = doc_email_input
    ORDER BY p.p_submit_date ASC;
END
$$ LANGUAGE plpgsql;


--- select * from get_all_patient_by_doctor_email('mohawaleeed2000@gmail.com');





--- 4 (get doctor username)

CREATE OR REPLACE FUNCTION get_doctor_username(email_input text)
RETURNS text AS $$
BEGIN
    RETURN (SELECT username FROM doctor WHERE email = email_input);
END;
$$ LANGUAGE plpgsql;


--- SELECT get_doctor_username('mohawaleeed2000@gmail.com');








---- 5 (select all drug_info data for patients)

CREATE OR REPLACE FUNCTION get_all_drug_info_for_patients(doc_email_input text)
RETURNS TABLE (
    d_pnt_id integer,
    info_submit_date date,
    drug text,
    dose numeric,
    ajcc_stage text,
    tnm text,
    grade text,
    notes text,
    p_name text
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
    d.d_pnt_id, 
    DATE(d.info_submit_date), 
    d.drug, 
    d.dose, 
    d.ajcc_stage, 
    d.tnm, 
    d.grade, 
    d.notes, 
    p.p_name
    FROM drug_info d
    JOIN patients p ON d.d_pnt_id = p.p_id
    JOIN doctor doc ON doc.email = p.doc_email
    WHERE p.doc_email = doc_email_input;
END;
$$ LANGUAGE plpgsql;


---- select * from get_all_drug_info_for_patients('mohawaleeed2000@gmail.com');




------------------------------------------- INSERT Functions -----------------------------------------------


--- 6 (add patient data)

CREATE OR REPLACE FUNCTION add_patient_data(
    p_name_input text, 
    p_date_input text,
    p_height_input integer, 
    p_weight_input integer, 
    p_gender_input boolean, 
    p_smoke_input boolean, 
    doc_email_input text
) 
RETURNS text 
AS $$
BEGIN
    BEGIN
        INSERT INTO patients (
            p_name, 
            p_bdate, 
            p_height, 
            p_weight, 
            p_gender, 
            p_smoke, 
            doc_email
        ) VALUES (
            p_name_input, 
            to_date(p_date_input, 'YYYY-MM-DD'), 
            p_height_input, 
            p_weight_input, 
            p_gender_input, 
            p_smoke_input, 
            doc_email_input
        );
        RETURN 'Patient Added Successfully';
    EXCEPTION WHEN others THEN
        RETURN 'Error Adding Patient';
    END;
END;
$$ LANGUAGE plpgsql;

-- SELECT add_patient_data('patient_2', '2001-10-22', 160, 65, True, False, 'doctor1@gmail.com');




--- 7 (add tumor data for patient)

CREATE OR REPLACE FUNCTION add_tumor_data(
    pnt_id_input integer, 
    cea_input integer DEFAULT NULL, 
    ca19_input integer DEFAULT NULL, 
    ca50_input integer DEFAULT NULL, 
    ca24_input integer DEFAULT NULL, 
    afp_input integer DEFAULT NULL
) 
RETURNS text 
AS $$
BEGIN
    BEGIN
        INSERT INTO tumors (
            pnt_id, 
            cea, 
            ca19, 
            ca50, 
            ca24, 
            afp
        ) VALUES (
            pnt_id_input, 
            cea_input, 
            ca19_input, 
            ca50_input, 
            ca24_input, 
            afp_input
        );
        RETURN 'Tumors Added Successfully';
    EXCEPTION WHEN others THEN
        RETURN 'Failed to Add Tumors';
    END;
END;
$$ LANGUAGE plpgsql;


-- SELECT add_tumor_data(5, NULL, NULL, NULL, 6, 6);





---- 8 (add drug info data)

CREATE OR REPLACE FUNCTION add_drug_info(
    pnt_id_input integer,
    drug_input text,
    dose_input numeric(10,3),
    ajcc_stage_input text,
    tnm_input text,
    grade_input text,
    notes_input text
)
RETURNS text AS $$
BEGIN
    BEGIN
        INSERT INTO drug_info(
            d_pnt_id, 
            drug, 
            dose, 
            ajcc_stage, 
            tnm, 
            grade, 
            notes
        )
        VALUES (
            pnt_id_input, 
            drug_input, 
            dose_input, 
            ajcc_stage_input, 
            tnm_input, 
            grade_input, 
            notes_input
        );
        RETURN 'Added Successfully';
    EXCEPTION WHEN others THEN
        RETURN 'Failed';
    END;
END;
$$ LANGUAGE plpgsql;

----- SELECT add_drug_info(8, 'second drug', 3.5, '0', 'Tis, N0, M0', 'G0', 'some additional notes');





-------------------------------------------------------- VERIFY Function -------------------------------------------------------

--- 9 (verify the encrypted password)

CREATE OR REPLACE FUNCTION verify_doctor_password(
    dr_email_input text, 
    dr_password_input text
)
RETURNS boolean
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 
        FROM doctor 
        WHERE email = dr_email_input 
        AND encrypted_password = crypt(dr_password_input, encrypted_password)
    );
END;
$$ LANGUAGE plpgsql;


--- SELECT verify_doctor_password('mohawaleeed2000@gmail.com', 'mohamed_password');


------------------------------------------------------ DELETE Functions -------------------------------------------------------

---- 10 (Delete patients and all his data in tumors and drug_info tables)


CREATE OR REPLACE FUNCTION delete_patient(p_id_input INTEGER) RETURNS TEXT AS $$
DECLARE
    rows_deleted INTEGER;
BEGIN
    DELETE FROM drug_info WHERE d_pnt_id = p_id_input;
    GET DIAGNOSTICS rows_deleted = ROW_COUNT;
    IF rows_deleted >= 0 THEN
        DELETE FROM tumors WHERE pnt_id = p_id_input;
        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        IF rows_deleted >= 0 THEN
            DELETE FROM patients WHERE p_id = p_id_input;
            GET DIAGNOSTICS rows_deleted = ROW_COUNT;
            IF rows_deleted > 0 THEN
                RETURN 'Deleted';
            END IF;
        END IF;
    END IF;
    RETURN 'Failed';
END;
$$ LANGUAGE plpgsql;

--- SELECT delete_patient(6);




--- 11 (Delete Tumors only and keep patient)

CREATE OR REPLACE FUNCTION delete_tumors_for_patient(p_id INTEGER) RETURNS TEXT AS $$
DECLARE
    rows_deleted INTEGER;
BEGIN
    DELETE FROM tumors WHERE pnt_id = p_id;
    GET DIAGNOSTICS rows_deleted = ROW_COUNT;
    IF rows_deleted > 0 THEN
        RETURN 'Deleted';
    ELSE
        RETURN 'Patient ID not found';
    END IF;
END;
$$ LANGUAGE plpgsql;

--- SELECT delete_tumors_for_patient(5);





---- 12 (delete drug_info only and keep patient)

CREATE OR REPLACE FUNCTION delete_drug_info_for_patient(p_id_input INTEGER) RETURNS TEXT AS $$
DECLARE
    rows_deleted INTEGER;
BEGIN
    DELETE FROM drug_info WHERE d_pnt_id = p_id_input;
    GET DIAGNOSTICS rows_deleted = ROW_COUNT;
    IF rows_deleted > 0 THEN
        RETURN 'Deleted';
    END IF;
    RETURN 'Failed or Patient Not Found ';
END;
$$ LANGUAGE plpgsql;

---- select delete_drug_info_for_patient(9);




----------------------------------------------- UPDATE Functions ----------------------------------------------------------



--- 13 (update docotr user_name)

CREATE OR REPLACE FUNCTION update_doctor_username(
    email_input text,
    username_input text
)
RETURNS text
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE doctor
    SET username = username_input
    WHERE email = email_input;

    IF FOUND THEN
        RETURN 'Username Updated';
    ELSE
        RETURN 'Failed to Update';
    END IF;
END;
$$;

--- SELECT update_doctor_username('esfgdf@mail.com', 'doc');










