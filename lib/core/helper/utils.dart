class RankUtils {
  static String medalAsset(String? rank) {
    switch (rank) {
      case 'المتطوع البرونزي':
        return 'assets/icons/medal1.png';
      case 'المتطوع الفضي':
        return 'assets/icons/medal2.png';
      case 'المتطوع الذهبي':
        return 'assets/icons/medal3.png';
      case 'المتطوع الماسي':
        return 'assets/icons/medal4.png';
      case 'المتطوع البلاتيني':
        return 'assets/icons/medal5.png';
      default:
        return 'assets/icons/medal1.png';
    }
  }

  static String rankTag(String? rank) {
    switch (rank) {
      case 'المتطوع البرونزي':
        return 'BRONZE';
      case 'المتطوع الفضي':
        return 'SILVER';
      case 'المتطوع الذهبي':
        return 'GOLD';
      case 'المتطوع الماسي':
        return 'DIAMOND';
      case 'المتطوع البلاتيني':
        return 'PLATINUM';
      default:
        return '';
    }
  }
}
