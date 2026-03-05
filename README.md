# Flutter Todo App

A **responsive, fully functional Todo application** built with Flutter, showcasing **Dart and Flutter competencies**.

This project focuses on **modular code structure, reactive state management and data persistence**, while keeping UI simple and clean.



## 🌟 Features

- **Add Tasks** – title, description, and priority (low, medium, high)
- **View Tasks** – see all tasks with status and priority
- **Mark Complete/Incomplete** – toggle task status instantly
- **Delete Tasks** – remove tasks safely
- **Filter Tasks** – by status: all, pending, completed
- **Sort Tasks** – by date or priority
- **Statistics Dashboard** – total, pending, completed, high-priority tasks
- **Persistent Storage** – tasks saved locally using `path_provider` (JSON file)
- **Responsive UI** – works on all screen sizes
- **Interactive UI Elements** – priority dots, fire FAB, filter chips



## ⚡ Skills Demonstrated

This project demonstrates **real-world Dart and Flutter abilities**:

### Dart Competencies
- Classes & OOP (`Task`, `TaskService`, `TaskNotifier`)
- Lists, Maps & collection manipulation
- Async programming & Futures
- File I/O and JSON encoding/decoding
- Data validation and error handling

### Flutter Competencies
- Reactive state management using **Riverpod**
- Responsive layouts using **SafeArea, ListView, Wrap, and Expanded**
- Material design components: AppBar, FAB, Chips, Icons
- Widget composition & modular structure
- Handling async data in UI with **AsyncNotifier & AsyncValue**

### Software Engineering Practices
- Separation of concerns: **models, services, screens, widgets**
- Reusable widgets
- Input validation & error handling
- Data persistence across app restarts
- Cross-platform compatibility (Android & iOS)



## 🏗 Project Structure

```text
lib/
├─ main.dart          # App entry point
├─ models/            # Task model
├─ services/          # TaskService (file I/O, CRUD) + TaskNotifier (state)
├─ screens/           # HomeScreen, AddTaskDialog
├─ widgets/           # Reusable widgets (none)
```



## ✅ Conclusion

This Flutter Todo App demonstrates **Dart fundamentals, modular Flutter architecture, reactive state management with Riverpod, persistent storage and responsive UI**.