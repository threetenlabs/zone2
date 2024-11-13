# Code Quality & Performance Guide

## Maintainability

### Clean Code Structure

Keep functions small and focused:

```
void handleSubmit() async {
  if (!validateInput()) return;
  await saveData();
  showSuccess();
}
```

### Consistent Naming

Use clear, descriptive names:

- Controllers: FoodController, not FCtrl
- Services: AuthenticationService, not AuthSvc
- Models: UserProfile, not UP
- Methods: fetchUserData(), not getData()

### Error Handling

Implement proper error boundaries:

```
try {
  await healthService.saveData();
} catch (e) {
  logger.e('Failed to save health data', e);
  NotificationService.to.showError('Save failed');
}
```

## Reusability

### Widget Composition

Break down complex widgets:

```
class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;

  CustomCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          child,
        ],
      ),
    );
  }
}
```

### Service Abstraction

Create reusable service methods:

```
class HealthService {
  Future<T> withErrorHandling<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e, stackTrace) {
      logger.e('Health service error', e, stackTrace);
      rethrow;
    }
  }
}
```

### Extension Methods

Add functionality without inheritance:

```
extension ContextExt on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
```

## Testability

### Dependency Injection

Use GetX for service injection:

```
class MyController extends GetxController {
  final service = Get.find<MyService>();
  final cache = Get.find<CacheService>();
}
```

### Mockable Interfaces

Create testable abstractions:

```
abstract class IHealthService {
  Future<void> saveData(HealthData data);
}

class HealthService implements IHealthService {
  @override
  Future<void> saveData(HealthData data) async {
    // Implementation
  }
}
```

### Testable State

Keep state observable and isolated:

```
class SearchController extends GetxController {
  final results = <SearchResult>[].obs;
  final isLoading = false.obs;

  Future<void> search(String query) async {
    isLoading.value = true;
    try {
      results.value = await performSearch(query);
    } finally {
      isLoading.value = false;
    }
  }
}
```

## Explainability

### Code Documentation

Document complex logic:

```
/// Calculates the user's zone points based on heart rate data
/// [heartRate] - Current heart rate in BPM
/// [maxHR] - User's maximum heart rate
/// Returns zone points (0-2) based on intensity
int calculateZonePoints(int heartRate, int maxHR) {
  final percentage = heartRate / maxHR;
  if (percentage >= 0.9) {
    return 2; // High intensity
  } else if (percentage >= 0.7) {
    return 1; // Moderate intensity
  } else {
    return 0; // Low intensity
  }
}
```

### Logging Strategy

Use structured logging:

```
logger.i('Saving health data', {
  'type': data.type,
  'value': data.value,
  'timestamp': data.timestamp,
});
```

### Clear Architecture

Follow consistent patterns:
lib/app/
├── modules/ # Feature modules
│ └── feature/
│ ├── controllers/
│ ├── views/
│ └── widgets/
├── services/ # Global services
├── models/ # Data models
└── utils/ # Utilities

## Performance Tips

### State Management

- Use .obs only for UI-bound state
- Avoid unnecessary rebuilds
- Use GetX workers for side effects

### Memory Management

- Dispose controllers and streams
- Cache heavy computations
- Use const constructors where possible

### UI Performance

- Use ListView.builder for long lists
- Implement pagination for large datasets
- Keep widget tree depth reasonable
