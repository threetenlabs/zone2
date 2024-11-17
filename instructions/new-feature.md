# Feature Development Guide

## Initial Setup

- Create feature branch: `feature/[name]`
- Verify Firebase config in firebase.json
- Follow existing patterns for consistency

## Backend Development

### Firestore Service

Add new methods to firebase_service.dart following pattern:

```
Future<void> saveData(String id, Map<String, dynamic> data) async {
  try {
    await _db.collection('collection').doc(id).set(data);
    logger.i('Data saved successfully');
  } catch (e) {
    logger.e('Error saving data: $e');
    rethrow;
  }
}
```

### Models

Create models in lib/app/models/ with:

- Required fields as final
- Factory constructors for JSON
- Clean serialization methods

```
  class MyModel {
    final String id;
    final String name;

    MyModel({required this.id, required this.name});

    factory MyModel.fromJson(Map<String, dynamic> json) {
      return MyModel(
        id: json['id'] as String,
        name: json['name'] as String,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'name': name,
      };
    }
  }
```

## Frontend Development

### Controllers

Use GetX controllers with:

- Observable (.obs) variables
- Clean error handling
- Service injection

```
  class MyController extends GetxController {
    final service = Get.find<MyService>();
    final data = <MyModel>[].obs;
    final number = 0.obs;
    final text = ''.obs;

    Future<void> loadData() async {
      try {
        data.value = await service.getData();
      } catch (e) {
        logger.e('Error: $e');
      }
    }

    Future<void> incrementNumber() async {
      number.value++;
    }

    Future<void> updateText(String newText) async {
      text.value = newText;
    }
  }
```

### Views

Create views with:

- GetView<Controller> base class
- Responsive layouts
- Proper state management

```
  class MyView extends GetView<MyController> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: Obx(() {
            if (controller.data.isEmpty) {
              return LoadingWidget();
            } else {
              return Column(
                children: [
                  Text(controller.text.value),
                  ListView.builder(
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) {
                  final item = controller.data[index];
                  return ListTile(
                        title: Text(item.name),
                      );
                    },
                  ),
                ],
              );
            }
          }),
        ),
      );
    }
  }
```

### UI Components

Build reusable widgets:

- Extract common UI patterns
- Use composition over inheritance
- Follow material design

```
class MyWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
```

- Widgets can also be GetView<Controller>

```
class MyWidget extends GetView<MyController> {
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(controller.text.value),
        onTap: onTap,
      ),
    );
  }
}
```

## Testing

Write tests for:

- Models
- Controllers
- Services
- Widget behavior

```
test('should load data', () async {
  final controller = MyController();
  await controller.loadData();
  expect(controller.data.length, greaterThan(0));
});
```

## Key Directories

- lib/app/modules/[feature]/views/ - UI components
- lib/app/modules/[feature]/controllers/ - Business logic
- lib/app/services/ - External services
- lib/app/models/ - Data models
- test/ - Test files

## Build & Deploy

- Use make mobile for builds
- Use make test for testing
- Monitor Firebase Crashlytics
- Keep documentation updated
