class Stats {
  late final int bossesSlain;
  late final int enemiesSlain;
  late final int tasksCompleted;
  late final int stagesCompleted;

  Stats.fromJson(Map<String, dynamic> data) {
    bossesSlain = data['bossesSlain'];
    enemiesSlain = data['enemiesSlain'];
    tasksCompleted = data['tasksCompleted'];
    stagesCompleted = data['stagesCompleted'];
  }
}
