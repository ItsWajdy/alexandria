import 'package:alexandria/add_edit_book/bloc/abstract_bloc.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_event.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_state.dart';
import 'package:alexandria/add_edit_book/widgets/floating_circular_button.dart';
import 'package:alexandria/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AbstractForm extends StatefulWidget {
  const AbstractForm({super.key});

  @override
  State<AbstractForm> createState() => _AbstractFormState();
}

class _AbstractFormState extends State<AbstractForm> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AlexandriaTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Book',
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
      body: BlocConsumer<AbstractBloc, AbstractState>(
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
              SnackBar(content: Text(state.errorMessage ?? 'Unknown error.')),
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
    return BlocBuilder<AbstractBloc, AbstractState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextFormField(
          key: const Key('abstractForm_titleInput_textField'),
          initialValue: state.title.value,
          onChanged: (value) =>
              context.read<AbstractBloc>().add(TitleChanged(text: value)),
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
    return BlocBuilder<AbstractBloc, AbstractState>(
      buildWhen: (previous, current) => previous.author != current.author,
      builder: (context, state) {
        return TextFormField(
          key: const Key('abstractForm_authorInput_textField'),
          initialValue: state.author.value,
          onChanged: (value) =>
              context.read<AbstractBloc>().add(AuthorChanged(text: value)),
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
    return BlocBuilder<AbstractBloc, AbstractState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextFormField(
          key: const Key('abstractForm_descriptionInput_textField'),
          initialValue: state.description.value,
          onChanged: (value) =>
              context.read<AbstractBloc>().add(DescriptionChanged(text: value)),
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
    return BlocBuilder<AbstractBloc, AbstractState>(
      buildWhen: (previous, current) => previous.image != current.image,
      builder: (context, state) {
        return TextFormField(
          key: const Key('abstractForm_imageInput_textField'),
          initialValue: state.image.value,
          onChanged: (value) =>
              context.read<AbstractBloc>().add(ImageChanged(text: value)),
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
    return BlocBuilder<AbstractBloc, AbstractState>(
      buildWhen: (previous, current) =>
          previous.publicationDate != current.publicationDate,
      builder: (context, state) {
        if (initialBuild && state.publicationDate != null) {
          dateInput.text = DateFormat.yMMMMd().format(state.publicationDate!);
          initialBuild = false;
        }
        return TextFormField(
          key: const Key('abstractForm_publicationDateInput_datePicker'),
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
              String formattedDate = DateFormat.yMMMMd().format(pickedDate);
              setState(() {
                dateInput.text = formattedDate;
              });

              context
                  .read<AbstractBloc>()
                  .add(PublicationDateChanged(date: pickedDate));
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
      key: const Key('abstractForm_submitButton'),
      size: 54,
      onClicked: () => context.read<AbstractBloc>().add(FormSubmitted()),
      child: Icon(
        Icons.save,
        color: AlexandriaTheme.highlightColor,
      ),
    );
  }
}
