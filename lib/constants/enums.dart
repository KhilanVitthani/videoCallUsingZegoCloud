enum REOCURRING_SESSION_TYPES { EveryDay, EveryWeek, Every2Week, EveryMonth }

extension Stringify on REOCURRING_SESSION_TYPES {
  String toStringName() {
    switch (this) {
      case REOCURRING_SESSION_TYPES.EveryDay:
        return 'Daily';
      case REOCURRING_SESSION_TYPES.EveryWeek:
        return 'Every Week';
      case REOCURRING_SESSION_TYPES.Every2Week:
        return 'Every 2 Week';
      case REOCURRING_SESSION_TYPES.EveryMonth:
        return 'Every Month';
    }
  }

  String? getId() {
    switch (this) {
      case REOCURRING_SESSION_TYPES.EveryDay:
        return '1';
      case REOCURRING_SESSION_TYPES.EveryWeek:
        return '2';
      case REOCURRING_SESSION_TYPES.Every2Week:
        return '3';
      case REOCURRING_SESSION_TYPES.EveryMonth:
        return '4';
      default:
        return '5';
    }
  }
}

enum WORKOUT_TYPES {
  All,
  Yoga,
  Running,
  Jogging,
  Boxing,
  Dance,
  Pilates,
  Hiit,
  Barre,
  Spinning,
  GymTime,
}

extension StringifyWORKOUT on WORKOUT_TYPES {
  String toStringName() {
    switch (this) {
      case WORKOUT_TYPES.All:
        return 'All Fitness';
      case WORKOUT_TYPES.Yoga:
        return 'Yoga';
      case WORKOUT_TYPES.Running:
        return 'Running';
      case WORKOUT_TYPES.Jogging:
        return 'Jogging';
      case WORKOUT_TYPES.Boxing:
        return 'Boxing';
      case WORKOUT_TYPES.Dance:
        return 'Dance';
      case WORKOUT_TYPES.Pilates:
        return 'Pilates';
      case WORKOUT_TYPES.Hiit:
        return 'Hiit';
      case WORKOUT_TYPES.Barre:
        return 'Barre';
      case WORKOUT_TYPES.Spinning:
        return 'Spinning';
      case WORKOUT_TYPES.GymTime:
        return 'Gym time';
    }
  }

  String? getId() {
    switch (this) {
      case WORKOUT_TYPES.Yoga:
        return '1';
      case WORKOUT_TYPES.Running:
        return '2';
      case WORKOUT_TYPES.Jogging:
        return '3';
      case WORKOUT_TYPES.GymTime:
        return '4';
      case WORKOUT_TYPES.Boxing:
        return '5';
      case WORKOUT_TYPES.Dance:
        return '6';
      case WORKOUT_TYPES.Pilates:
        return '7';
      case WORKOUT_TYPES.Hiit:
        return '8';
      case WORKOUT_TYPES.Barre:
        return '9';
      case WORKOUT_TYPES.Spinning:
        return '10';

      default:
        return '11';
    }
  }
}

enum GENDER {
  female,
  male,
  neutral,
  nonBinary,
  agender,
  pangender,
}

extension StringifyGENDER on GENDER {
  String toStringName() {
    switch (this) {
      case GENDER.female:
        return 'Female';
      case GENDER.male:
        return 'Male';
      case GENDER.neutral:
        return 'Neutral';
      case GENDER.nonBinary:
        return 'Non-Binary';
      case GENDER.agender:
        return 'Agender';
      case GENDER.pangender:
        return 'Pangender';
    }
  }

  String toId() {
    switch (this) {
      case GENDER.female:
        return 'female';
      case GENDER.male:
        return 'male';
      case GENDER.neutral:
        return 'neutral';
      case GENDER.nonBinary:
        return 'nonBinary';
      case GENDER.agender:
        return 'agender';
      case GENDER.pangender:
        return 'pangender';
    }
  }
}

enum PARTICIPANTTS {
  ontToFour,
  fourToTen,
  tenToTwenty,
}

extension StringifyPARTICIPANTTS on PARTICIPANTTS {
  String toStringName() {
    switch (this) {
      case PARTICIPANTTS.ontToFour:
        return "1-4";
      case PARTICIPANTTS.fourToTen:
        return "5-10";
      case PARTICIPANTTS.tenToTwenty:
        return "11-20";
    }
  }

  String? minParticipent() {
    switch (this) {
      case PARTICIPANTTS.ontToFour:
        return "1";
      case PARTICIPANTTS.fourToTen:
        return '5';
      case PARTICIPANTTS.tenToTwenty:
        return '11';

      default:
        return '1';
    }
  }

  String? maxParticipent() {
    switch (this) {
      case PARTICIPANTTS.ontToFour:
        return "4";
      case PARTICIPANTTS.fourToTen:
        return '10';
      case PARTICIPANTTS.tenToTwenty:
        return '10';

      default:
        return '4';
    }
  }
}

var arraySearchKeywords = [
  "Jogging or running",
  "Swimming",
  "Tennis",
  "Rollerblading/ roller skating",
  "Basketball",
  "football",
  "Jump rope",
  "Volleyball",
  "Dance",
  "Biking",
  "Stretching",
  "Weight Training",
  "Yoga",
  "Tai Chi or Qi Gong",
  "Pilates",
  "Water aerobics",
  "HIIT (high-intensity interval training)",
  "Boxing",
  "Barre",
  "Cycling",
  "Spinning"
];

enum CHALLENGE_STATUS {
  notJoined,
  creator,
  joined,
  invited,
  completed,
}

extension StringifyCHALLENGE_STATUS on CHALLENGE_STATUS {
  String toStringName() {
    switch (this) {
      case CHALLENGE_STATUS.notJoined:
        return "";
      case CHALLENGE_STATUS.creator:
        return "creator";
      case CHALLENGE_STATUS.joined:
        return "joined";
      case CHALLENGE_STATUS.invited:
        return "invited";
      case CHALLENGE_STATUS.completed:
        return "completed";
    }
  }
}

enum SESSION_STATUS {
  notJoined,
  creator,
  joined,
  invited,
  pending,
  decline,
  cancelled,
  leave,
}

extension StringifySESSION_STATUS on SESSION_STATUS {
  String toStringName() {
    switch (this) {
      case SESSION_STATUS.notJoined:
        return "";
      case SESSION_STATUS.creator:
        return "Creator";
      case SESSION_STATUS.joined:
        return "Joined";
      case SESSION_STATUS.invited:
        return "invited";
      case SESSION_STATUS.decline:
        return "Decline";
      case SESSION_STATUS.cancelled:
        return "Cancelled";
      case SESSION_STATUS.leave:
        return "Leave";
      case SESSION_STATUS.pending:
        return "Pending";
    }
  }

  String toStringId() {
    switch (this) {
      case SESSION_STATUS.notJoined:
        return "";
      case SESSION_STATUS.creator:
        return "creator";
      case SESSION_STATUS.joined:
        return "joined";
      case SESSION_STATUS.invited:
        return "invited";
      case SESSION_STATUS.decline:
        return "decline";
      case SESSION_STATUS.cancelled:
        return "cancelled";
      case SESSION_STATUS.leave:
        return "leave";
      case SESSION_STATUS.pending:
        return "pending";
    }
  }
}
