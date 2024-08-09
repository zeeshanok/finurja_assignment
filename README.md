# finurja_assignment

A banking app made for my Finurja internship candidate assignment.

## Running
Generate dummy data by running
```bash
python generator.py 10
```
where `10` is the number of bank accounts to be generated (replace with any number).

Run
```bash
flutter pub get
dart run build_runner build
```
to install the packages and build the `freezed` models

Now run
```bash
flutter run --release
```
to run the app in release mode