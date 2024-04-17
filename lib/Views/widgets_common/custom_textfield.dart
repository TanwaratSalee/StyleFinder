import 'package:flutter_finalproject/consts/consts.dart';

Widget customTextField({
  String? title,
  String? label,
  TextEditingController? controller,
  bool isPass = false,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        Text(
          title,
          style: const TextStyle(
            color: blackColor,
            fontFamily: bold,
            fontSize: 16,
          ),
        ),
      const SizedBox(height: 8),
      TextField(
        obscureText: isPass,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          hintStyle: const TextStyle(
            color: greyDark1,
          ),
          filled: true,
          fillColor: thinGrey0,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: whiteColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: greyColor),
          ),
        ),
      ),
    ],
  );
}

class CustomTextFieldd extends StatefulWidget {
  final String label;
  final bool isPass;
  final TextEditingController controller;
  final bool readOnly;

  const CustomTextFieldd({
    Key? key,
    required this.label,
    this.isPass = false,
    this.readOnly = false,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFieldd> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPass; // Only obscure text if it's a password field.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
            labelText: widget.label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide.none, // No border to maintain the flat design
            ),
            suffixIcon: widget.isPass
                ? IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: thinGrey0,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: whiteColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: greyColor),
            ) // Fill color to match the container
            ),
        style: const TextStyle(fontSize: 16), // Adjust text style as needed
      ),
    );
  }
}
