import 'package:flutter/widgets.dart';

Image placeHolderImage = Image.asset(
  "images/placeHolder2.webp",
  fit: BoxFit.cover,
);

class CarImage extends StatelessWidget {
  const CarImage({super.key, required this.carImage});
  final Image? carImage;
  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      fit: BoxFit.cover,
      placeholder: placeHolderImage.image,
      image: carImage == null ? placeHolderImage.image : carImage!.image,
    );
  }
}
