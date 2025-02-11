final candidates = [
  {
    "name": "Hershel Rayen P",
    "rollno": "2022BC12",
    "img": "assets/candidates/1.jpg"
  },
  {"name": "Indhuja S", "rollno": "2022BC13", "img": "assets/candidates/2.jpg"},
  {"name": "Janane S", "rollno": "2022BC14", "img": "assets/candidates/3.jpg"},
  {
    "name": "Jeevajothi M",
    "rollno": "2022BC15",
    "img": "assets/candidates/4.jpg"
  },
  {
    "name": "Kamatchi R",
    "rollno": "2022BC16",
    "img": "assets/candidates/5.jpg"
  },
  {
    "name": "kanish Rahima J",
    "rollno": "2022BC17",
    "img": "assets/candidates/6.jpg"
  },
  {"name": "kaviya R", "rollno": "2022BC18", "img": "assets/candidates/7.jpg"},
  {
    "name": "Krishna Priya M",
    "rollno": "2022BC19",
    "img": "assets/candidates/8.jpg"
  },
  {"name": "Lavanya N", "rollno": "2022BC20", "img": "assets/candidates/9.jpg"},
  {
    "name": "Mahalakshmi B",
    "rollno": "2022BC21",
    "img": "assets/candidates/10.jpg"
  },
  {
    "name": "Mari Mohana K",
    "rollno": "2022BC22",
    "img": "assets/candidates/11.jpg"
  },
  {
    "name": "Maria Christina Jefrin B",
    "rollno": "2022BC23",
    "img": "assets/candidates/12.jpg"
  },
  {
    "name": "Mahalakshmi S",
    "rollno": "2023BC25",
    "img": "assets/candidates/13.jpg"
  },
  {
    "name": "Mohana Sankari V M S",
    "rollno": "2023BC26",
    "img": "assets/candidates/14.jpg"
  },
  {
    "name": "Neemath Sharfah I",
    "rollno": "2023BC27",
    "img": "assets/candidates/15.jpg"
  },
  {
    "name": "Nivetha S",
    "rollno": "2023BC28",
    "img": "assets/candidates/16.jpg"
  },
  {
    "name": "Oritha ezihlarasi J",
    "rollno": "2023BC29",
    "img": "assets/candidates/17.jpg"
  },
  {
    "name": "Priya Dharshini P",
    "rollno": "2023BC30",
    "img": "assets/candidates/18.jpg"
  },
  {"name": "Aswini A", "rollno": "2023BC12", "img": "assets/candidates/19.jpg"},
  {
    "name": "Bujalakshmi B V",
    "rollno": "2023BC13",
    "img": "assets/candidates/20.jpg"
  },
  {
    "name": "Dharshini G",
    "rollno": "2023BC14",
    "img": "assets/candidates/21.jpg"
  },
  {
    "name": "Ferdolina Roselin S",
    "rollno": "2023BC15",
    "img": "assets/candidates/22.jpg"
  },
  {
    "name": "Gana Shree S",
    "rollno": "2023BC16",
    "img": "assets/candidates/23.jpg"
  },
  {"name": "Gokila S", "rollno": "2023BC17", "img": "assets/candidates/24.jpg"},
  {
    "name": "Hemavarshini T",
    "rollno": "2024BC15",
    "img": "assets/candidates/25.jpg"
  },
  {
    "name": "Jainab Tahseen M",
    "rollno": "2024BC16",
    "img": "assets/candidates/26.jpg"
  },
  {
    "name": "Jananipriya V",
    "rollno": "2024BC17",
    "img": "assets/candidates/27.jpg"
  },
  {
    "name": "Jeevika M",
    "rollno": "2024BC18",
    "img": "assets/candidates/28.jpg"
  },
  {
    "name": "Jeniliya Benadit J",
    "rollno": "2024BC19",
    "img": "assets/candidates/29.jpg"
  },
  {
    "name": "Jofino Mary S",
    "rollno": "2024BC20",
    "img": "assets/candidates/30.jpg"
  },
  {"name": "Kaviya G", "rollno": "2024BC21", "img": "assets/candidates/31.jpg"},
  {
    "name": "Keerthana Devi R",
    "rollno": "2024BC22",
    "img": "assets/candidates/32.jpg"
  },
  {"name": "Lasili O", "rollno": "2024BC23", "img": "assets/candidates/33.jpg"},
  {
    "name": "Lohithha A",
    "rollno": "2024BC24",
    "img": "assets/candidates/34.jpg"
  },
  {
    "name": "Maragatha Valli R",
    "rollno": "2024BC25",
    "img": "assets/candidates/35.jpg"
  },
  {"name": "Mathi M", "rollno": "2024BC26", "img": "assets/candidates/36.jpg"}
];

String? getImagePath(String id) {
  try {
    // Find the image path by matching the name
    for (var candidate in candidates) {
      if (candidate["rollno"] == id) {
        return candidate["img"] ?? "assets/candidates/default.png";
      }
    }
    // Return the image path if found
    return "assets/candidates/default.png";
  } catch (e) {
    return "assets/candidates/default.png"; // Default image in case of error
  }
}

Map getcandiadates(String roll) {
  try {
    // Find the image path by matching the name
    for (var candidate in candidates) {
      if (candidate["rollno"] == roll) {
        return {"name": candidate["name"]!, "img": candidate["img"]!};
      }
    }
    // return null;
    // Return the image path if found
    return {"rollno": "N/A", "img": "assets/candidates/default.png"};
  } catch (e) {
    return {"rollno": "N/A", "img": "assets/candidates/default.png"};
    // Default image in case of error
  }
}
