import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/core/widgets/safe_scaffold.dart';

class ContactUsPage extends StatelessWidget {
   ContactUsPage({super.key});
  final _nameController = TextEditingController();
  final _emailController  = TextEditingController();
  final _messageController = TextEditingController();
  final _formKeyContactUs = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      
      //  appBar: AppBar(
      //   backgroundColor: transparent,
      //   leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back, color: white,)),title: Text("Contact us", style: TextStyle(color: white),),),
      body: Stack(children: [
      Image.asset('assets/images/Contact.jpg'),
    Container(
      padding: const EdgeInsets.all(16),
  height: MediaQuery.of(context).size.height,
  width: MediaQuery.of(context).size.width,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Center( // Center aligns the inner container without forcing it to expand
    child: ClipRRect(borderRadius: BorderRadius.circular(12),

      child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Frosted effect

        child: Container(
           padding: const EdgeInsets.all(32), // Padding inside the frosted box
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
          
          child: Form(
            key: _formKeyContactUs,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
             // Limits the column to the minimum height required
              children: [
                const Text("Contact Us",style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),),
                CustomTextFieldWithSquare(

                  controller: _nameController,
                  label: "Name",
                  hintText: "Please enter your name",
                  validator: (value) {
                    if(value=='' ||value==null || value!.isEmpty){
                      return 'Entry cannot be empty';

                    }
                    
                  },
                ),
                CustomTextFieldWithSquare(
                  controller: _emailController,
                  label: "Email",
                  hintText: "Please enter your email",
                  validator: (value) {
                    if(value=='' ||value==null || value!.isEmpty){
                      return 'Entry cannot be empty';
                    }
                    if (value == null || value.isEmpty) {
    return 'Email cannot be empty';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
                    
                  },
                ),
                CustomTextFieldWithSquare(
                  controller: _messageController,
                  label: "Message",
                  hintText: "Please enter your query",
                  tall: true,
                   validator: (value) {
                    if(value=='' ||value==null || value!.isEmpty){
                      return 'Entry cannot be empty';

                    }
                    
                  },
                ),
                    TextButton(
              onPressed: () {
                if(_formKeyContactUs.currentState!.validate())
                context.push('/about-us');
                // Add your sign-in logic here
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
)

    ],),);
  }
}

class CustomTextFieldWithSquare extends StatelessWidget {
  const CustomTextFieldWithSquare({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.tall, this.validator
  });
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool? tall;
  final String? Function(String?)? validator;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align the label to the left
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8), // Adds some spacing between label and text field
          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
            height: tall == true ? 200 : null, // Conditional height for tall text fields
            child: TextFormField(
              validator: validator,
              maxLines: tall == true ? 5 : 1, // Adjust maxLines for tall inputs
              controller: controller,
              decoration: InputDecoration(
              
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                hintText: hintText, // Placeholder text inside the TextField
                hintStyle: const TextStyle(
                  color: Colors.grey, // Hint text color
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
