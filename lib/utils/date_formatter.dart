String formatDate(DateTime date) {
  const months = [
    'Јан', 'Фев', 'Мар', 'Апр', 'Мај', 'Јун',
    'Јул', 'Авг', 'Сеп', 'Окт', 'Ное', 'Дек'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
