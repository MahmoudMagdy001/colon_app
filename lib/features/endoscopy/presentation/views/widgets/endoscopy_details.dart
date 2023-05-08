import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../manager/cubit/endoscopy_cubit.dart';

class EndoscopyDetails extends StatefulWidget {
  const EndoscopyDetails({super.key});

  @override
  State<EndoscopyDetails> createState() => _EndoscopyDetailsState();
}

class _EndoscopyDetailsState extends State<EndoscopyDetails> {
  @override
  Widget build(BuildContext context) {
    void resetImage() {
      setState(() {
        BlocProvider.of<EndoscopyCubit>(context).imageEndoscopy = null;
      });
    }

    return BlocBuilder<EndoscopyCubit, EndoscopyState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  padding: const EdgeInsets.all(25),
                  width:
                      constraints.maxWidth < 550 ? constraints.maxWidth : 440,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Upload Endoscopy images here',
                              style: Styles.textStyle25,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            height: 58,
                            child: CustomButton(
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              text: 'Reset'.toUpperCase(),
                              onPressed: () {
                                resetImage();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      BlocProvider.of<EndoscopyCubit>(context).imageEndoscopy !=
                              null
                          ? Image.file(
                              BlocProvider.of<EndoscopyCubit>(context)
                                  .imageEndoscopy!,
                              width: double.infinity,
                              height: 350,
                            )
                          : const Icon(
                              Icons.question_mark,
                              size: 250,
                              color: kTextColor,
                            ),
                      const SizedBox(height: 25),
                      Text(
                        'Results Here..',
                        style: Styles.textStyle25.copyWith(color: kTextColor),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Upload Image'.toUpperCase(),
                              backgroundColor: kButtonColor,
                              textColor: Colors.white,
                              onPressed: () {
                                BlocProvider.of<EndoscopyCubit>(context)
                                    .pickImageEndoscopy(ImageSource.gallery);
                              },
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: CustomButton(
                              backgroundColor: kButtonColor,
                              text: 'Submit'.toUpperCase(),
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}