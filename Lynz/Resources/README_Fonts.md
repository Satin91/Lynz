# Система шрифтов Lynz

## Обзор

Система шрифтов Lynz предоставляет удобный доступ к шрифтам SF Pro с предустановленными размерами, весами и кернингом для обеспечения консистентности в дизайне.

## Доступные шрифты

### Семантические названия (рекомендуется)

| Название | Размер | Вес | Кернинг | Использование |
|----------|--------|-----|---------|---------------|
| `lzHeader` | 70 | Bold | -2% | Главный заголовок |
| `lzTitle` | 33 | Semibold | - | Основной заголовок |
| `lzSectionHeader` | 24 | Semibold | - | Заголовок секции |
| `lzSubtitle` | 20 | Medium | - | Подзаголовок |
| `lzBody` | 17 | Medium | -0.43 | Основной текст |
| `lzCaption` | 18 | Light | - | Дополнительный текст |
| `lzAccent` | 15 | Semibold | - | Акцентный текст |
| `lzEmphasis` | 16 | Bold | - | Выделенный текст |
| `lzSmall` | 14 | Regular | -0.43 | Мелкий текст |

### Технические названия

| Название | Размер | Вес | Кернинг | Использование |
|----------|--------|-----|---------|---------------|
| `lynzBold70` | 70 | Bold | -2% | Большие заголовки |
| `lynzSemibold33` | 33 | Semibold | - | Основные заголовки |
| `lynzSemibold24` | 24 | Semibold | - | Заголовки секций |
| `lynzMedium20` | 20 | Medium | - | Подзаголовки |
| `lynzMedium17` | 17 | Medium | -0.43 | Основной текст |
| `lynzLight18` | 18 | Light | - | Дополнительный текст |
| `lynzRegular14` | 14 | Regular | -0.43 | Мелкий текст |
| `lynzSemibold15` | 15 | Semibold | - | Акцентный текст |
| `lynzBold16` | 16 | Bold | - | Выделенный текст |

## Способы использования

### 1. Прямое применение через Font (рекомендуется)

```swift
Text("Заголовок")
    .font(.lzHeader)

Text("Подзаголовок")
    .font(.lzTitle)

Text("Основной текст")
    .font(.lzBody)
```

### 2. Через модификаторы View

```swift
Text("Заголовок")
    .lynzBold70()

Text("Подзаголовок")
    .lynzSemibold24()

Text("Основной текст")
    .lynzMedium17()
```

### 3. Через константы (рекомендуется)

```swift
// Заголовки
Text("Большой заголовок")
    .font(.lynzHeadlines.large)

Text("Средний заголовок")
    .font(.lynzHeadlines.medium)

Text("Малый заголовок")
    .font(.lynzHeadlines.small)

// Основной текст
Text("Большой текст")
    .font(.lynzBody.large)

Text("Средний текст")
    .font(.lynzBody.medium)

Text("Малый текст")
    .font(.lynzBody.small)

// Дополнительный текст
Text("Дополнительная информация")
    .font(.lynzCaption.primary)

Text("Акцентный текст")
    .font(.lynzCaption.secondary)

Text("Выделенный текст")
    .font(.lynzCaption.tertiary)
```

## Примеры использования в UI

### Семантические названия (рекомендуется)

```swift
// Главный заголовок страницы
Text("Добро пожаловать в Lynz")
    .font(.lzHeader)
    .foregroundColor(.primary)

// Основной заголовок
Text("Настройки профиля")
    .font(.lzTitle)
    .foregroundColor(.primary)

// Заголовок секции
Text("Личная информация")
    .font(.lzSectionHeader)
    .foregroundColor(.primary)

// Подзаголовок
Text("Управление аккаунтом")
    .font(.lzSubtitle)
    .foregroundColor(.secondary)

// Основной текст
Text("Здесь вы можете изменить настройки вашего профиля")
    .font(.lzBody)
    .foregroundColor(.primary)

// Дополнительный текст
Text("Нажмите для получения справки")
    .font(.lzCaption)
    .foregroundColor(.secondary)

// Акцентный текст
Text("Важно!")
    .font(.lzAccent)
    .foregroundColor(.blue)

// Выделенный текст
Text("Обязательное поле")
    .font(.lzEmphasis)
    .foregroundColor(.red)

// Мелкий текст
Text("ID: 12345")
    .font(.lzSmall)
    .foregroundColor(.secondary)
```

### Заголовки

```swift
VStack(alignment: .leading, spacing: 16) {
    Text("Главный заголовок")
        .font(.lzHeader)
        .foregroundColor(.primary)
    
    Text("Подзаголовок страницы")
        .font(.lzTitle)
        .foregroundColor(.secondary)
    
    Text("Заголовок секции")
        .font(.lzSectionHeader)
        .foregroundColor(.primary)
}
```

### Карточки

```swift
VStack(alignment: .leading, spacing: 12) {
    Text("Название карточки")
        .font(.lzBody.large)
        .fontWeight(.semibold)
    
    Text("Описание карточки с подробной информацией о содержимом")
        .font(.lzBody.medium)
        .foregroundColor(.secondary)
    
    Text("Дополнительная информация")
        .font(.lzCaption.primary)
        .foregroundColor(.secondary)
}

### Кнопки

```swift
Button("Основная кнопка") {
    // действие
}
.font(.lzBody.medium)
.foregroundColor(.white)
.padding()
.background(Color.blue)
.cornerRadius(8)

Button("Вторичная кнопка") {
    // действие
}
.font(.lzCaption.secondary)
.foregroundColor(.blue)
.padding()
.background(Color.blue.opacity(0.1))
.cornerRadius(8)
```

### Формы

```swift
VStack(spacing: 16) {
    Text("Форма входа")
        .font(.lzHeadlines.small)
    
    TextField("Email", text: $email)
        .font(.lzBody.medium)
    
    TextField("Пароль", text: $password)
        .font(.lzBody.medium)
    
    Text("Забыли пароль?")
        .font(.lzCaption.primary)
        .foregroundColor(.blue)
}
```

## Преимущества системы

### Семантические названия
1. **Читаемость кода**: `.lzHeader` вместо `.lynzBold70`
2. **Дизайнерский подход**: Названия соответствуют назначению
3. **Легкость понимания**: `lzBody` понятнее чем `lynzMedium17`
4. **Быстрое редактирование**: Легко изменить размер заголовка
5. **Консистентность**: Единый стиль именования с приставкой `lz`

### Общие преимущества
1. **Консистентность**: Все шрифты имеют предустановленные параметры
2. **Удобство**: Простые названия для быстрого доступа
3. **Масштабируемость**: Легко добавлять новые шрифты
4. **Типобезопасность**: Компилятор проверяет корректность
5. **Документированность**: Каждый шрифт имеет описание
6. **Группировка**: Логическая организация по назначению

## Добавление новых шрифтов

### Шаг 1: Добавление в расширение Font

```swift
extension Font {
    static let lynzNewFont = Font.custom("SF Pro", size: 22)
        .weight(.medium)
        .kerning(-0.01)
}
```

### Шаг 2: Добавление модификатора View

```swift
extension View {
    func lynzNewFont() -> some View {
        self.font(.lynzNewFont)
    }
}
```

### Шаг 3: Добавление в константы

```swift
struct LynzFontConstants {
    struct Headlines {
        static let new = Font.lynzNewFont
    }
}
```

## Лучшие практики

1. **Используйте константы** для логически связанных шрифтов
2. **Следуйте иерархии** заголовков (large → medium → small)
3. **Применяйте кернинг** для улучшения читаемости
4. **Тестируйте на разных устройствах** для проверки масштабирования
5. **Документируйте назначение** каждого шрифта
6. **Используйте семантические названия** для констант

## Совместимость

Все шрифты используют системный шрифт SF Pro, который:
- Доступен на всех устройствах Apple
- Автоматически адаптируется к настройкам доступности
- Поддерживает динамический тип
- Оптимизирован для различных размеров экрана

## Поддержка

При возникновении вопросов или необходимости добавления новых шрифтов, обратитесь к команде разработки или создайте issue в репозитории проекта.
