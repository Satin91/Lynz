# Интеграция CoreData в Lynz - Упрощенная Архитектура

## Архитектурные принципы

### 1. Многослойная архитектура без протоколов
- **CoreDataService** - только технические CRUD операции
- **DataRepository** - универсальный слой для работы с данными
- **EntityMapper** - преобразование между моделями и сущностями
- **LocalDataInteractor** - бизнес-логика и специфичные операции
- **ViewStore** - управление состоянием UI

### 2. Разделение ответственности
- **Repository** - абстракция над источником данных
- **EntityMapper** - знает как работать с конкретными типами
- **Interactor** - только бизнес-логика, не знает о CoreData

## Структура компонентов

### CoreDataService (Технический слой)
```swift
class CoreDataService: ObservableObject {
    func save<T: NSManagedObject>(_ entity: T) throws
    func delete<T: NSManagedObject>(_ entity: T) throws
    func update<T: NSManagedObject>(_ entity: T) throws
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T]
}
```

**Особенности:**
- Работает только с `NSManagedObject`
- Не знает о доменных моделях
- Только технические операции

### DataRepository (Абстракция данных)
```swift
class DataRepository: ObservableObject {
    func save<T: Codable & Identifiable>(_ item: T) throws
    func delete<T: Codable & Identifiable>(_ item: T) throws
    func update<T: Codable & Identifiable>(_ item: T) throws
    func fetch<T: Codable & Identifiable>(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [T]
}
```

**Особенности:**
- Универсальный интерфейс для любых типов
- Работает с доменными моделями (`Codable & Identifiable`)
- Абстрагирует источник данных (CoreData, Realm, SQLite)

### EntityMapper (Преобразование данных)
```swift
class EntityMapper {
    func createEntity<T: Codable & Identifiable>(from item: T) throws -> NSManagedObject
    func findEntity<T: Codable & Identifiable>(for item: T) throws -> NSManagedObject
    func updateEntity<T: Codable & Identifiable>(_ entity: NSManagedObject, with item: T) throws
    func createModel<T: Codable & Identifiable>(from entity: NSManagedObject, as type: T.Type) throws -> T?
}
```

**Особенности:**
- Знает как работать с конкретными типами
- Автоматический маппинг через reflection
- Специализированная логика для сложных типов

### LocalDataInteractor (Бизнес-логика)
```swift
class LocalDataInteractor: ObservableObject {
    // Специфичные операции для планов
    func savePlan(_ plan: Plan) throws
    func fetchPlans(for date: Date?) throws -> [Plan]
    
    // Универсальные операции
    func save<T: Codable & Identifiable>(_ item: T) throws
    func fetch<T: Codable & Identifiable>(_ type: T.Type) throws -> [T]
}
```

**Особенности:**
- Только бизнес-логика
- Использует Repository для операций с данными
- Не знает о CoreData или EntityMapper

## Преимущества упрощенной архитектуры

### 1. **Простота и понятность**
- Нет сложных протоколов и абстракций
- Прямые зависимости между классами
- Легко понять и отладить

### 2. **Полная абстракция от CoreData**
- Interactor работает только с доменными моделями
- Легко заменить CoreData на Realm или SQLite
- Repository скрывает детали реализации

### 3. **Автоматический маппинг**
- Не нужно вручную копировать свойства
- Reflection автоматически обрабатывает простые случаи
- Специализированные мапперы для сложных типов

### 4. **Универсальность**
- Repository работает с любыми `Codable & Identifiable` типами
- EntityMapper может быть расширен для новых типов
- Interactor легко расширяется новыми операциями

## Как использовать

### В ViewStore
```swift
final class CalendarViewStore: ViewStore<CalendarState, CalendarIntent> {
    private let localDataInteractor: LocalDataInteractor
    
    init(localDataInteractor: LocalDataInteractor) {
        self.localDataInteractor = localDataInteractor
        super.init(initialState: CalendarState())
    }
    
    override func reduce(state: inout CalendarState, intent: CalendarIntent) -> Effect<CalendarIntent> {
        case .loadPlans:
            return .asyncTask { [weak self] in
                guard let self = self else { return .none }
                do {
                    let plans = try self.localDataInteractor.fetchPlans()
                    return .action(.plansLoaded(plans))
                } catch {
                    return .action(.errorOccurred(error.localizedDescription))
                }
            }
    }
}
```

### Добавление нового типа данных
```swift
// 1. Создать EntityMapper для нового типа
class UserEntityMapper: EntityMapper {
    // Реализация для User
}

// 2. Добавить в DependencyStore
lazy var userEntityMapper = UserEntityMapper(coreDataService: coreDataService)
lazy var userRepository = DataRepository(coreDataService: coreDataService, entityMapper: userEntityMapper)

// 3. Создать Interactor
class UserDataInteractor {
    private let repository: DataRepository
    
    func saveUser(_ user: User) throws {
        try repository.save(user)
    }
}
```

## Примеры автоматического маппинга

### Простой случай
```swift
struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
}

// EntityMapper автоматически создаст:
// - UserEntity с атрибутами name и email
// - Копирование свойств через reflection
```

### Сложный случай
```swift
struct Plan: Codable, Identifiable {
    let id: UUID
    var role: Role
    var date: Date
    var tasks: [TaskCategory]
}

// PlanEntityMapper знает как:
// - Создать PlanEntity с правильными атрибутами
// - Преобразовать enum Role в String
// - Создать связанные TaskCategoryEntity
// - Настроить отношения между сущностями
```

## Следующие шаги

1. **Создать Core Data модель в Xcode**
2. **Протестировать автоматический маппинг**
3. **Добавить новые типы данных**
4. **Реализовать кэширование и синхронизацию**

Эта упрощенная архитектура обеспечивает чистоту, понятность и легкость расширения без сложных протоколов!
