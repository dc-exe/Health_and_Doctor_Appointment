class CardModel {
  String name;
  String doctor;
  int cardBackground;
  String cardImage;

  CardModel(this.name, this.doctor, this.cardBackground, this.cardImage);
}

List<CardModel> nearbyCards = [
  new CardModel("Dr. Sheldon Cooper", "Cardiologist", 0xFFec407a, "assets/Nearby/doc1.jpg"),
  new CardModel("Dr. Sheldon Cooper", "Dentist", 0xFF5c6bc0, "assets/Nearby/doc2.jpg"),
  new CardModel("Dr. Drake Ramoray", "Eye Special", 0xFFfbc02d, "assets/Nearby/doc3.jpg"),
  new CardModel("Dr. Sheldon Cooper", "Orthopaedic", 0xFF1565C0, "assets/Nearby/doc1.jpg"),
  new CardModel("Dr. Sheldon Cooper", "Paediatrician", 0xFF2E7D32, "assets/Nearby/doc1.jpg"),
  new CardModel("Dr. Sheldon Cooper", "Eye Special", 0xFFfbc02d, "assets/Nearby/doc1.jpg"),
  new CardModel("Dr. Sheldon Cooper", "Orthopaedic", 0xFF1565C0, "assets/Nearby/doc1.jpg"),
  new CardModel("Dr. Sheldon Cooper", "Paediatrician", 0xFF2E7D32, "assets/Nearby/doc1.jpg"),
];
