import 'package:flutter/material.dart';
import '../models/birthday/birthday_event.dart';
import '../models/birthday/birthday_expense.dart';
import '../models/birthday/birthday_task.dart';
import '../models/birthday/birthday_guest.dart';
import '../models/birthday/birthday_gift.dart';
import '../models/birthday/birthday_timeline_item.dart';
import '../models/birthday/birthday_memory.dart';
import '../screens/birthday/services/birthday_service.dart';

class BirthdayProvider extends ChangeNotifier {
  List<BirthdayEvent> _events = [];
  BirthdayEvent? _activeEvent;
  List<BirthdayExpense> _expenses = [];
  List<BirthdayTask> _tasks = [];
  List<BirthdayGuest> _guests = [];
  List<BirthdayGift> _gifts = [];
  List<BirthdayTimelineItem> _timeline = [];
  List<BirthdayMemory> _memories = [];
  bool _isLoading = false;

  // Getters
  List<BirthdayEvent> get events => _events;
  BirthdayEvent? get activeEvent => _activeEvent;
  List<BirthdayExpense> get expenses => _expenses;
  List<BirthdayTask> get tasks => _tasks;
  List<BirthdayGuest> get guests => _guests;
  List<BirthdayGift> get gifts => _gifts;
  List<BirthdayTimelineItem> get timeline => _timeline;
  List<BirthdayMemory> get memories => _memories;
  bool get isLoading => _isLoading;

  // ===== Derived Stats =====
  List<BirthdayEvent> get upcomingEvents => _events.where((e) => e.daysRemaining > 0).toList()
    ..sort((a, b) => a.eventDate.compareTo(b.eventDate));

  int get totalTasksCompleted => _tasks.where((t) => t.isCompleted).length;
  int get totalTasksPending => _tasks.where((t) => !t.isCompleted).length;
  double get taskCompletionPercent => _tasks.isEmpty ? 0 : (totalTasksCompleted / _tasks.length * 100);

  double get totalEstimatedBudget => _expenses.fold(0, (s, e) => s + e.estimatedCost);
  double get totalActualSpending => _expenses.fold(0, (s, e) => s + e.actualCost);
  double get remainingBudget => (_activeEvent?.totalBudget ?? 0) - totalActualSpending;
  double get budgetUtilization => (_activeEvent?.totalBudget ?? 0) == 0
      ? 0
      : (totalActualSpending / _activeEvent!.totalBudget * 100).clamp(0, 999);

  int get totalInvited => _guests.length;
  int get confirmedGuests => _guests.where((g) => g.rsvpStatus == 'accepted').length;
  int get pendingGuests => _guests.where((g) => g.rsvpStatus == 'pending').length;
  int get declinedGuests => _guests.where((g) => g.rsvpStatus == 'declined').length;

  double get eventReadiness {
    if (_activeEvent == null) return 0;
    double score = 0;
    int factors = 0;
    // Task completion
    if (_tasks.isNotEmpty) {
      score += taskCompletionPercent;
      factors++;
    }
    // Has guests
    if (_guests.isNotEmpty) {
      score += (_guests.where((g) => g.rsvpStatus == 'accepted').length / _guests.length * 100);
      factors++;
    }
    // Has budget set
    if (_expenses.isNotEmpty) {
      score += 100;
      factors++;
    }
    // Theme selected
    if (_activeEvent!.theme.isNotEmpty && _activeEvent!.theme != 'Minimal Classy') {
      score += 100;
      factors++;
    }
    return factors == 0 ? 0 : score / factors;
  }

  // ===== INITIALIZATION =====
  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await BirthdayService.loadEvents();
      if (_events.isNotEmpty && _activeEvent == null) {
        _activeEvent = _events.first;
      }
      if (_activeEvent != null) {
        await loadEventData(_activeEvent!.id);
      }
    } catch (e) {
      debugPrint('BirthdayProvider.loadAll error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadEventData(String eventId) async {
    _expenses = await BirthdayService.getEventExpenses(eventId);
    _tasks = await BirthdayService.getEventTasks(eventId);
    _guests = await BirthdayService.getEventGuests(eventId);
    _gifts = await BirthdayService.getEventGifts(eventId);
    _timeline = await BirthdayService.getEventTimeline(eventId);
    _memories = await BirthdayService.getEventMemories(eventId);
    notifyListeners();
  }

  void setActiveEvent(BirthdayEvent event) {
    _activeEvent = event;
    loadEventData(event.id);
  }

  // ===== EVENT CRUD =====
  Future<void> addEvent(BirthdayEvent event) async {
    await BirthdayService.addEvent(event);
    _events.add(event);
    _activeEvent = event;
    // Add default tasks & timeline for new event
    final defaultTasks = BirthdayTask.defaultTasks(event.id);
    for (final t in defaultTasks) {
      await BirthdayService.addTask(t);
    }
    final defaultTimeline = BirthdayTimelineItem.defaultTimeline(event.id);
    for (final t in defaultTimeline) {
      await BirthdayService.addTimelineItem(t);
    }
    await loadEventData(event.id);
    notifyListeners();
  }

  Future<void> updateEvent(BirthdayEvent event) async {
    await BirthdayService.updateEvent(event);
    final idx = _events.indexWhere((e) => e.id == event.id);
    if (idx != -1) _events[idx] = event;
    if (_activeEvent?.id == event.id) _activeEvent = event;
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    await BirthdayService.deleteEvent(eventId);
    _events.removeWhere((e) => e.id == eventId);
    if (_activeEvent?.id == eventId) {
      _activeEvent = _events.isNotEmpty ? _events.first : null;
      if (_activeEvent != null) {
        await loadEventData(_activeEvent!.id);
      } else {
        _expenses = [];
        _tasks = [];
        _guests = [];
        _gifts = [];
        _timeline = [];
        _memories = [];
      }
    }
    notifyListeners();
  }

  // ===== EXPENSE CRUD =====
  Future<void> addExpense(BirthdayExpense expense) async {
    await BirthdayService.addExpense(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  Future<void> updateExpense(BirthdayExpense expense) async {
    await BirthdayService.updateExpense(expense);
    final idx = _expenses.indexWhere((e) => e.id == expense.id);
    if (idx != -1) _expenses[idx] = expense;
    notifyListeners();
  }

  Future<void> deleteExpense(String expenseId) async {
    await BirthdayService.deleteExpense(expenseId);
    _expenses.removeWhere((e) => e.id == expenseId);
    notifyListeners();
  }

  // ===== TASK CRUD =====
  Future<void> addTask(BirthdayTask task) async {
    await BirthdayService.addTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(BirthdayTask task) async {
    await BirthdayService.updateTask(task);
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) _tasks[idx] = task;
    notifyListeners();
  }

  Future<void> toggleTask(String taskId) async {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      _tasks[idx].isCompleted = !_tasks[idx].isCompleted;
      await BirthdayService.updateTask(_tasks[idx]);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    await BirthdayService.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  // ===== GUEST CRUD =====
  Future<void> addGuest(BirthdayGuest guest) async {
    await BirthdayService.addGuest(guest);
    _guests.add(guest);
    notifyListeners();
  }

  Future<void> updateGuest(BirthdayGuest guest) async {
    await BirthdayService.updateGuest(guest);
    final idx = _guests.indexWhere((g) => g.id == guest.id);
    if (idx != -1) _guests[idx] = guest;
    notifyListeners();
  }

  Future<void> deleteGuest(String guestId) async {
    await BirthdayService.deleteGuest(guestId);
    _guests.removeWhere((g) => g.id == guestId);
    notifyListeners();
  }

  // ===== GIFT CRUD =====
  Future<void> addGift(BirthdayGift gift) async {
    await BirthdayService.addGift(gift);
    _gifts.add(gift);
    notifyListeners();
  }

  Future<void> updateGift(BirthdayGift gift) async {
    await BirthdayService.updateGift(gift);
    final idx = _gifts.indexWhere((g) => g.id == gift.id);
    if (idx != -1) _gifts[idx] = gift;
    notifyListeners();
  }

  Future<void> deleteGift(String giftId) async {
    await BirthdayService.deleteGift(giftId);
    _gifts.removeWhere((g) => g.id == giftId);
    notifyListeners();
  }

  // ===== TIMELINE CRUD =====
  Future<void> addTimelineItem(BirthdayTimelineItem item) async {
    await BirthdayService.addTimelineItem(item);
    _timeline.add(item);
    _timeline.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    notifyListeners();
  }

  Future<void> updateTimelineItem(BirthdayTimelineItem item) async {
    await BirthdayService.updateTimelineItem(item);
    final idx = _timeline.indexWhere((t) => t.id == item.id);
    if (idx != -1) _timeline[idx] = item;
    notifyListeners();
  }

  Future<void> deleteTimelineItem(String itemId) async {
    await BirthdayService.deleteTimelineItem(itemId);
    _timeline.removeWhere((t) => t.id == itemId);
    notifyListeners();
  }

  // ===== MEMORY CRUD =====
  Future<void> addMemory(BirthdayMemory memory) async {
    await BirthdayService.addMemory(memory);
    _memories.add(memory);
    notifyListeners();
  }

  Future<void> deleteMemory(String memoryId) async {
    await BirthdayService.deleteMemory(memoryId);
    _memories.removeWhere((m) => m.id == memoryId);
    notifyListeners();
  }
}
