# ecampusguard

eCampusGuard is a smart entry system for campus parking.

## How to add new features

Adding new features with the least amount of effort is a project goal. Therefore we have used tools for ease of adding new features. One of the main tools is called mason. 

### Before you start

Install mason by running the following commands in your terminal:
```sh
# 🎯 Activate from https://pub.dev
dart pub global activate mason_cli

# 🚀 Initialize mason
mason init
```

Then you need to add the cubit_page mason template
```sh
# Install locally
mason add cubit_page
```

Then to create a feature simply run the command below, replacing `featurename` with what you need. `Note: the featurename needs to adhere to dart naming conventions (No spaces, No special character except underscore and period)`
```sh
mason make cubit_page -o ./lib/features/ --name featurename
```

The following will be generated inside the features folder:
```
features
├── featurename
│   ├── cubit
│   │   ├── featurename_cubit.dart
│   │   └── featurename_state.dart
│   ├── view
│   │   ├── featurename_page.dart
│   │   └── featurename_view.dart
│   └── featurename.dart
└── ...
```

### What are the files and do they do?
#### cubit
The cubit folder includes your cubit logic.

`featurename_cubit.dart` 👉 This is the cubit, think of it like the controller of your UI state. (ie. Login cubit changes the state of the login button to disabled)

`featurename_state.dart` 👉 This is the cubit states, these are the states your cubit can emit. You can listen to the changes in state using a BlocConsumer,BlocListener,BlocBuilder and rebuild your UI as you desire.

#### view
The view folder includes your views.

`featurename_page.dart` 👉 This is the entry point to your feature's views. A feature may have many different views. So this page can be used to dynamically rebuild the page with a certain view.

`featurename_view.dart` 👉 This is usually the main view for your feature. You can start designing your UI from here.
