import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.title,
    required this.description,
    required this.topImagePath,
    required this.bottomImagePath,
  });

  const PageContent.first()
      : this(
          title: 'Welcome to Retro Bank!',
          description:
              'Experience banking the old-school way with a modern twist – '
              'send money through my mobile app!',
          topImagePath: MediaRes.onBoardingImageOne,
          bottomImagePath: MediaRes.onBoardingImageTwo,
        );
  const PageContent.second()
      : this(
          title: '',
          description: 'Remember the days when banking was slow? Well, '
              'now you can relish the lightning-fast pace and convenience!',
          topImagePath: MediaRes.onBoardingImageThree,
          bottomImagePath: MediaRes.onBoardingImageFour,
        );
  const PageContent.third()
      : this(
          title: '',
          description:
              'Once upon a time, banking was a leisurely stroll, but now, '
              'buckle up for a speedy ride like never before!',
          topImagePath: MediaRes.onBoardingImageFive,
          bottomImagePath: MediaRes.onBoardingImageSix,
        );

  final String title;
  final String description;
  final String topImagePath;
  final String bottomImagePath;

  @override
  List<String?> get props =>
      [title, description, topImagePath, bottomImagePath];
}
