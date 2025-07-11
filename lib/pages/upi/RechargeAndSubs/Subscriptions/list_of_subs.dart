final List<String> categories = [
  "OTT",
  "Music",
  "Health & Wellness",
  "Education",
  "Others",
];

final Map<String, List<Map<String, dynamic>>> providersByCategory = {
  "OTT": [
    {
      "name": "ZEE5",
      "cashback": "125",
      "image": "assets/images/banner_recharge.png",
      "plans": [
        {
          "title": "ZEE5 Premium (3 Months)",
          "price": "399",
          "desc": "Ad-Free | HD Quality | 3 Devices",
        },
        {
          "title": "ZEE5 Premium (12 Months)",
          "price": "599",
          "desc": "Ad-Free | 4K Quality | 5 Devices",
        },
      ],
    },
    {
      "name": "SonyLIV",
      "cashback": "50",
      "image": "assets/images/sonyliv.jpeg",
      "plans": [
        {
          "title": "SonyLIV Premium (1 year)",
          "price": "999",
          "desc": "Ad-Free | Full HD | All Devices",
        },
        {
          "title": "SonyLIV Mobile (1 year)",
          "price": "599",
          "desc": "Ad-Supported | Mobile Only",
        },
      ],
    },
    {
      "name": "Amazon Prime",
      "cashback": "0",
      "image": "assets/images/prime.png",
      "plans": [
        {
          "title": "Prime Monthly",
          "price": "299",
          "desc": "Ad-Free | Prime Delivery | Prime Video",
        },
        {
          "title": "Prime Quarterly",
          "price": "599",
          "desc": "Best Value for 3 Months",
        },
        {
          "title": "Prime Annual",
          "price": "1499",
          "desc": "1-Year All-In-One Access",
        },
      ],
    },
    {
      "name": "JioHotstar",
      "cashback": "0",
      "image": "assets/images/hotstar.jpeg",
      "plans": [
        {
          "title": "JioHotstar Mobile (1 year)",
          "price": "499",
          "desc": "Ad-Supported | 1 Device | Mobile Only",
        },
        {
          "title": "JioHotstar Super (1 year)",
          "price": "899",
          "desc": "Ad-Supported | 2 Devices | All Devices",
        },
        {
          "title": "JioHotstar Premium (1 year)",
          "price": "1499",
          "desc": "Ad-Free | 4 Devices | All Devices",
        },
      ],
    },
    {
      "name": "Airtel Xstream Play",
      "cashback": "0",
      "image": "assets/images/xstream.jpeg",
      "plans": [
        {
          "title": "Xstream Basic Plan (3 Months)",
          "price": "149",
          "desc": "Ad Supported | Mobile Only",
        },
        {
          "title": "Xstream Premium Plan (1 Year)",
          "price": "999",
          "desc": "Ad-Free | All Devices",
        },
      ],
    },
  ],
  "Music": [
    {
      "name": "Spotify",
      "cashback": "20",
      "image": "assets/images/spotify.png",
      "plans": [
        {
          "title": "Spotify Mini (1 Day)",
          "price": "7",
          "desc": "Daily Plan | Mobile Only",
        },
        {
          "title": "Spotify Premium (1 Month)",
          "price": "119",
          "desc": "Ad-Free | High Quality Audio",
        },
      ],
    },
    {
      "name": "Pocket FM",
      "cashback": "30",
      "image": "assets/images/pocket_fm.png",
      "plans": [
        {
          "title": "Pocket FM Premium (6 Months)",
          "price": "399",
          "desc": "Unlimited Access to Stories",
        },
      ],
    },
    {
      "name": "Hangama Music",
      "cashback": "30",
      "image": "assets/images/hungama_music.png",
      "plans": [
        {
          "title": "Hangama Music Plus (1 Year)",
          "price": "499",
          "desc": "Ad-Free | HD Audio",
        },
      ],
    },
    {
      "name": "Hungama Play",
      "cashback": "30",
      "image": "assets/images/hungama_play.jpeg",
      "plans": [
        {
          "title": "Hungama Play Pro (1 Year)",
          "price": "799",
          "desc": "Ad-Free | All Genres",
        },
      ],
    },
    {
      "name": "Shemaroo",
      "cashback": "30",
      "image": "assets/images/shemaroo_ibadat.jpeg",
      "plans": [
        {
          "title": "Shemaroo Ibaadat Annual",
          "price": "499",
          "desc": "Spiritual Content | All Devices",
        },
      ],
    },
  ],
  "Health & Wellness": [
    {
      "name": "APOLLO 24|7",
      "cashback": "70",
      "image": "assets/images/apollo.png",
      "plans": [
        {
          "title": "Apollo Circle Plan (3 Months)",
          "price": "299",
          "desc": "Free Consultations | Discounts",
        },
      ],
    },
    {
      "name": "FITPASS",
      "cashback": "40",
      "image": "assets/images/fitpass.jpeg",
      "plans": [
        {
          "title": "FITPASS PRO Plan (Monthly)",
          "price": "999",
          "desc": "Unlimited Gym Access",
        },
      ],
    },
    {
      "name": "Bajaj finserv Health Limited",
      "cashback": "70",
      "image": "assets/images/bajaj.png",
      "plans": [
        {
          "title": "Bajaj Health Membership",
          "price": "499",
          "desc": "Health Checkups + Discounts",
        },
      ],
    },
    {
      "name": "Parentlane",
      "cashback": "40",
      "image": "assets/images/parentline.png",
      "plans": [
        {
          "title": "Parentlane BabyCare (Yearly)",
          "price": "1499",
          "desc": "New Parent Guidance",
        },
      ],
    },
    {
      "name": "MediBuddy",
      "cashback": "70",
      "image": "assets/images/medibuddy.png",
      "plans": [
        {
          "title": "MediBuddy Plus (1 Year)",
          "price": "999",
          "desc": "OPD + Lab Discounts",
        },
      ],
    },
  ],
  "Education": [
    {
      "name": "BYJU'S",
      "cashback": "100",
      "image": "assets/images/byjus.png",
      "plans": [
        {
          "title": "BYJU'S Foundation Course (1 Year)",
          "price": "4999",
          "desc": "Complete Foundation Class Pack",
        },
      ],
    },
    {
      "name": "Unacademy",
      "cashback": "80",
      "image": "assets/images/unacademy.jpeg",
      "plans": [
        {
          "title": "Unacademy Plus (1 Month)",
          "price": "599",
          "desc": "Live + Recorded + Notes",
        },
        {
          "title": "Unacademy Iconic (1 Year)",
          "price": "32000",
          "desc": "Mentor Support + Printed Notes",
        },
      ],
    },
  ],
  "Others": [
    {
      "name": "The Indian Express",
      "cashback": "70",
      "image": "assets/images/the_indian_express.png",
      "plans": [
        {
          "title": "Indian Express Digital (Monthly)",
          "price": "149",
          "desc": "Full Digital Access",
        },
      ],
    },
    {
      "name": "Furlenco",
      "cashback": "40",
      "image": "assets/images/furlenco.png",
      "plans": [
        {
          "title": "Furlenco Furniture Plan",
          "price": "999",
          "desc": "Furniture Rental | 1 Month",
        },
      ],
    },
    {
      "name": "HT Digital",
      "cashback": "70",
      "image": "assets/images/ht_digital.jpeg",
      "plans": [
        {
          "title": "HT Premium (Yearly)",
          "price": "399",
          "desc": "Ad-Free HT Epaper Access",
        },
      ],
    },
    {
      "name": "MyUpchar",
      "cashback": "40",
      "image": "assets/images/myupcare.jpeg",
      "plans": [
        {
          "title": "MyUpchar Basic Care",
          "price": "249",
          "desc": "Basic Online Consultation",
        },
      ],
    },
  ],
};
