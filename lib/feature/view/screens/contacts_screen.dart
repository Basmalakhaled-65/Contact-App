import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/feature/view/widgets/custom_material_button.dart';
import 'package:contact_app/feature/view/widgets/custom_text_form_field.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> saveContact() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the name and phone number.'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('contacts').add({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xffF6F8FC),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xff17233C),
          ),
        ),
        title: const Text(
          'Add Contact',
          style: TextStyle(
            color: Color(0xff17233C),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xffDDF5F2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 50,
                  color: Color(0xff20B2AA),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Create New Contact',
              style: TextStyle(
                color: Color(0xff17233C),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add the contact details below to keep them in your contact list.',
              style: TextStyle(
                color: Color(0xff7B8497),
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            CustomTextFormField(
              label: 'Full Name',
              hint: 'Enter contact name',
              controller: nameController,
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              label: 'Phone Number',
              hint: 'Enter phone number',
              controller: phoneController,
            ),

            const SizedBox(height: 35),

            if (isSaving)
              const Center(
                child: CircularProgressIndicator(color: Color(0xff20B2AA)),
              )
            else
              CustomMaterialButton(
                title: 'Save Contact',
                onPressed: saveContact,
              ),
          ],
        ),
      ),
    );
  }
}
