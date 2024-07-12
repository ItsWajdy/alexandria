# alexandria

A simple Flutter app to manage a personal book library (hence the name).

This app has basic CRUD, search, and favorites screens. It's configured with [BLoC](https://pub.dev/packages/bloc) for state management and [Dio](https://pub.dev/packages/dio) for HTTP networking.

<br />
<div>
  &emsp;&emsp;&emsp;
  <img src="https://github.com/ItsWajdy/alexandria/blob/master/screenshots/all_books_page.png" alt="Home Page" width="330">
  &emsp;&emsp;&emsp;&emsp;
  <img src="https://github.com/ItsWajdy/alexandria/blob/master/screenshots/book_details_page.png" alt="Book Details" width="330">
</div>
<br />

More screenshots can be found in the [screenshots](https://github.com/ItsWajdy/alexandria/tree/master/screenshots) folder.


## Run

Install dependencies with 

```
flutter pub get
```

Run the app 

```
flutter run
```


## Under the Hood

### Backend

Although the app is built on the assumption that it will communicate with a server backend, it doesn't <i>technically</i> (in its current state) send or recieve data over the network. Rather, data is stored locally and is reached by mocking a Restful API.

This is handled by the `mock_backend` package which simulates a backend and has mocks for all needed API requests that the app uses.

The package is split into two main parts, one responsible for receiveing API requests and sending responses, and the other responsible for managing local data storage using [Hive](https://docs.hivedb.dev/#/).

  
## Tests

The test folder contains unit and widget tests for all BLoCs, Cubits and screes.

## Known Issues

- `BookDetails` widget tests fail due to `Overflow` exceptions.
