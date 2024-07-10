import 'package:alexandria/new_book/cubit/new_book_cubit.dart';
import 'package:alexandria/new_book/widgets/floating_circular_button.dart';
import 'package:alexandria/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NewBookForm extends StatefulWidget {
  const NewBookForm({super.key});

  @override
  State<NewBookForm> createState() => _NewBookFormState();
}

class _NewBookFormState extends State<NewBookForm> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AlexandriaTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'New Book',
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
      body: BlocConsumer<NewBookCubit, NewBookState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Success'),
              ),
            );
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
                    _TitleInput(),
                    const SizedBox(
                      height: 5,
                    ),
                    _AuthorInput(),
                    const SizedBox(
                      height: 5,
                    ),
                    _DescriptionInput(),
                    const SizedBox(
                      height: 5,
                    ),
                    _ImageInput(),
                    const SizedBox(
                      height: 5,
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
    return BlocBuilder<NewBookCubit, NewBookState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextField(
          key: const Key('newBookForm_titleInput_textField'),
          onChanged: (email) =>
              context.read<NewBookCubit>().titleChanged(email),
          decoration: InputDecoration(
            labelText: 'Title',
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
    return BlocBuilder<NewBookCubit, NewBookState>(
      buildWhen: (previous, current) => previous.author != current.author,
      builder: (context, state) {
        return TextField(
          key: const Key('newBookForm_authorInput_textField'),
          onChanged: (email) =>
              context.read<NewBookCubit>().authorChanged(email),
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
    return BlocBuilder<NewBookCubit, NewBookState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextField(
          key: const Key('newBookForm_descriptionInput_textField'),
          onChanged: (email) =>
              context.read<NewBookCubit>().descriptionChanged(email),
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
    return BlocBuilder<NewBookCubit, NewBookState>(
      buildWhen: (previous, current) => previous.image != current.image,
      builder: (context, state) {
        return TextField(
          key: const Key('newBookForm_imageInput_textField'),
          onChanged: (email) =>
              context.read<NewBookCubit>().imageChanged(email),
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
  TextEditingController dateInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewBookCubit, NewBookState>(
      buildWhen: (previous, current) =>
          previous.publicationDate != current.publicationDate,
      builder: (context, state) {
        return TextField(
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

              context.read<NewBookCubit>().publicationDateChanged(pickedDate);
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
      onClicked: () => context.read<NewBookCubit>().saveNewBook(),
      child: Icon(
        Icons.save,
        color: AlexandriaTheme.highlightColor,
      ),
    );
  }
}
