import 'package:alexandria/edit_book/edit_book.dart';
import 'package:alexandria/edit_book/widgets/floating_circular_button.dart';
import 'package:alexandria/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditBookForm extends StatefulWidget {
  const EditBookForm({super.key});

  @override
  State<EditBookForm> createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AlexandriaTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Book',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      floatingActionButton: _SubmitButton(),
      body: BlocConsumer<EditBookCubit, EditBookState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            context.go('/');
          }
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Unknown'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            color: const Color(0xFFF4F4F4),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Book Details',
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: _TitleInput(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: _AuthorInput(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: _DescriptionInput(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: _ImageInput(),
                    ),
                    _PublicationDateInput(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextFormField(
          key: const Key('newBookForm_titleInput_textField'),
          initialValue: state.title.value,
          onChanged: (email) =>
              context.read<EditBookCubit>().titleChanged(email),
          decoration: InputDecoration(
            labelText: 'Title',
            hintText: state.title.value,
            errorText:
                state.title.displayError != null ? 'Invalid Title' : null,
          ),
        );
      },
    );
  }
}

class _AuthorInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      buildWhen: (previous, current) => previous.author != current.author,
      builder: (context, state) {
        return TextFormField(
          key: const Key('newBookForm_authorInput_textField'),
          initialValue: state.author.value,
          onChanged: (email) =>
              context.read<EditBookCubit>().authorChanged(email),
          decoration: InputDecoration(
            labelText: 'Author',
            errorText:
                state.author.displayError != null ? 'Invalid Author' : null,
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextFormField(
          key: const Key('newBookForm_descriptionInput_textField'),
          initialValue: state.description.value,
          onChanged: (email) =>
              context.read<EditBookCubit>().descriptionChanged(email),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description',
            errorText: state.description.displayError != null
                ? 'Invalid Description'
                : null,
          ),
        );
      },
    );
  }
}

class _ImageInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      buildWhen: (previous, current) => previous.image != current.image,
      builder: (context, state) {
        return TextFormField(
          key: const Key('newBookForm_imageInput_textField'),
          initialValue: state.image.value,
          onChanged: (email) =>
              context.read<EditBookCubit>().imageChanged(email),
          decoration: InputDecoration(
            labelText: 'Image',
            errorText: state.image.displayError != null ? 'Invalid Path' : null,
          ),
        );
      },
    );
  }
}

class _PublicationDateInput extends StatefulWidget {
  @override
  State<_PublicationDateInput> createState() => _PublicationDateInputState();
}

class _PublicationDateInputState extends State<_PublicationDateInput> {
  bool initialBuild = true;
  TextEditingController dateInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      buildWhen: (previous, current) =>
          previous.publicationDate != current.publicationDate,
      builder: (context, state) {
        if (initialBuild && state.publicationDate != null) {
          dateInput.text =
              DateFormat('yyyy-MM-dd').format(state.publicationDate!);
          initialBuild = false;
        }
        return TextFormField(
          key: const Key('newBookForm_publicationDateInput_datePicker'),
          controller: dateInput,
          decoration: const InputDecoration(
            labelText: 'Publication Date',
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1800),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                dateInput.text = formattedDate;
              });

              context.read<EditBookCubit>().publicationDateChanged(pickedDate);
            }
          },
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingCircularButton(
      key: const Key('newBookForm_submitButton'),
      size: 54,
      onClicked: () => context.read<EditBookCubit>().saveNewBook(),
      child: Icon(
        Icons.save,
        color: AlexandriaTheme.highlightColor,
      ),
    );
  }
}
