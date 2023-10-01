import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class User {
  String name = '';
  String email = '';
  String address = '';
}

class WeeklyPlan {
  String day = '';
  List<String> plans = [];

  WeeklyPlan(this.day, this.plans);
}

class MyApp extends StatelessWidget {
  static ThemeMode themeMode = ThemeMode.light;
  static bool notificationsEnabled = true;
  static User user = User();

  static void restartAppWithThemeMode(
      BuildContext context, ThemeMode themeMode) {
    MyApp.themeMode = themeMode;
    runApp(MyApp());
  }

  static void toggleNotifications() {
    notificationsEnabled = !notificationsEnabled;
  }

  static void saveUserInfo() {
    print('Kullanıcı bilgileri kaydedildi:');
    print('Ad: ${user.name}');
    print('E-Mail: ${user.email}');
    print('Adres: ${user.address}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haftalık Program',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> days = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  List<WeeklyPlan> generateWeeklyPlans() {
    final List<WeeklyPlan> weeklyPlans = [];
    for (final day in days) {
      final dailyPlans = getRandomPlans(3);
      final weeklyPlan = WeeklyPlan(day, dailyPlans);
      weeklyPlans.add(weeklyPlan);
    }
    return weeklyPlans;
  }

  List<String> getRandomPlans(int count) {
    final List<String> plans = [
      'Spor yapmak',
      'Kitap okumak',
      'Müzik dinlemek',
      'Yemek yapmak',
      'Resim yapmak',
      'Bahçe işleri',
      'Film izlemek',
      'Alışveriş yapmak',
      'Arkadaşlarla buluşmak',
    ];

    final Random random = Random();
    final selectedPlans = <String>[];
    for (int i = 0; i < count; i++) {
      final randomIndex = random.nextInt(plans.length);
      selectedPlans.add(plans[randomIndex]);
    }

    return selectedPlans;
  }

  @override
  Widget build(BuildContext context) {
    final weeklyPlans = generateWeeklyPlans();
    return Scaffold(
      appBar: AppBar(
        title: Text('Haftalık Program'),
        leading: Image.network(
          'https://sanatakademi.com.tr/uploads/2023/02/cagdas-sanat-akimlari-2.jpg',
          width: 40, // Resmin genişliği
          height: 40, // Resmin yüksekliği
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.green, // Arka plan rengi
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Mustafa Alp Haftalık Listesi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Yazı rengi
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final weeklyPlan = weeklyPlans[index];
                return DayButton(weeklyPlan: weeklyPlan);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DayButton extends StatelessWidget {
  final WeeklyPlan weeklyPlan;

  DayButton({required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text(weeklyPlan.day),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DayDetailsPage(weeklyPlan: weeklyPlan),
          ),
        );
      },
    );
  }
}

class DayDetailsPage extends StatelessWidget {
  final WeeklyPlan weeklyPlan;

  DayDetailsPage({required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${weeklyPlan.day} Planı'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              'Günün Planları',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (int i = 0; i < weeklyPlan.plans.length; i++)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${i + 1}. Plan: ${weeklyPlan.plans[i]}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme = 'Light'; // Varsayılan tema

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ayarlar Sayfası',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text('Tema Seçimi'),
              trailing: DropdownButton<String>(
                value: selectedTheme,
                items: <String>['Light', 'Dark'].map((String theme) {
                  return DropdownMenuItem<String>(
                    value: theme,
                    child: Text(theme),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTheme = newValue!;
                    if (selectedTheme == 'Light') {
                      MyApp.restartAppWithThemeMode(context, ThemeMode.light);
                    } else {
                      MyApp.restartAppWithThemeMode(context, ThemeMode.dark);
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Bildirimler'),
              trailing: Switch(
                value: MyApp.notificationsEnabled,
                onChanged: (bool newValue) {
                  MyApp.toggleNotifications();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = MyApp.user.name;
    emailController.text = MyApp.user.email;
    addressController.text = MyApp.user.address;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Ad'),
              onChanged: (value) => MyApp.user.name = value,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-Mail'),
              onChanged: (value) => MyApp.user.email = value,
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Adres'),
              onChanged: (value) => MyApp.user.address = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                MyApp.saveUserInfo();
              },
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
