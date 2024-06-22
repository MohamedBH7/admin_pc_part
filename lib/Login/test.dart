import 'package:flutter/material.dart';


class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 1],
                colors: [Colors.purple, Colors.blue])),
        padding: EdgeInsets.all(constraints.maxWidth > 600 ? 64 : 0),
        child: Center(
          child: Container(
            width: 700,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(constraints.maxWidth > 600 ? 10 : 0),
              color: const Color(0xFF0f0f10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Color(0xFF19191a),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      chatDetailsWidget(),
                      if (constraints.maxWidth > 600) avatarGroupWidget(),
                      chatButtonsWidget(),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      chatMessageListWidget(),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.only(
                    left: 48,
                    right: 32,
                    top: 24,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: Color(0xFF19191a),
                      ),
                    ),
                  ),
                  child: Row(children: [
                    avatarWidget(
                      imgUrl:
                      "https://images.pexels.com/photos/1438275/pexels-photo-1438275.jpeg?auto=compress&cs=tinysrgb&crop=faces&fit=crop&h=200&w=200",
                      size: 42,
                      hasBorder: false,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF222425),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF43a0ff),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Write a message',
                          hintStyle: const TextStyle(
                            color: Color(0xFF434548),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF303336),
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://assets.codepen.io/344846/send_black_24dp.png"),
                            scale: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }
}

Widget chatButtonsWidget() {
  return (Wrap(
    spacing: 16,
    children: [
      InkWell(
        onTap: () {},
        child: Container(
          height: 24,
          width: 24,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://assets.codepen.io/344846/search_black_24dp.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      InkWell(
        onTap: () {},
        child: Container(
          height: 24,
          width: 24,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://assets.codepen.io/344846/turned_in_not_black_24dp.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      InkWell(
        onTap: () {},
        child: Container(
          height: 24,
          width: 24,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://assets.codepen.io/344846/more_horiz_black_24dp.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ],
  ));
}

Widget chatDetailsWidget() {
  return (Wrap(
    children: [
      InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF19191a),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://assets.codepen.io/344846/tag_black_24dp.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "design",
                style: TextStyle(
                  color: Color(0xFFb7b7b8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 8),
      InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF19191a),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://assets.codepen.io/344846/people_outline_black_24dp.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "32",
                style: TextStyle(
                  color: Color(0xFFb7b7b8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ));
}

Widget avatarWidget(
    {required String imgUrl, double size = 32, bool hasBorder = true}) {
  return (Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(imgUrl),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(100),
      boxShadow: hasBorder
          ? [
        const BoxShadow(
          color: Color(0xFF0f0f10),
          spreadRadius: 4,
          blurRadius: 0,
          offset: Offset(0, 0),
        ),
      ]
          : [],
    ),
  ));
}

Widget avatarGroupWidget() {
  return (Row(
    children: [
      avatarWidget(
          imgUrl:
          "https://images.pexels.com/photos/1438275/pexels-photo-1438275.jpeg?auto=compress&cs=tinysrgb&crop=faces&fit=crop&h=200&w=200"),
      Transform.translate(
        offset: const Offset(-12, 0),
        child: avatarWidget(
            imgUrl:
            "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ"),
      ),
      Transform.translate(
        offset: const Offset(-24, 0),
        child: avatarWidget(
            imgUrl:
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=046c29138c1335ef8edee7daf521ba50"),
      ),
      Transform.translate(
        offset: const Offset(-36, 0),
        child: avatarWidget(
            imgUrl:
            "https://images.unsplash.com/photo-1549068106-b024baf5062d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ"),
      ),
    ],
  ));
}

Widget chatMessageWidget(
    {required String imgUrl,
      required String username,
      required String date,
      required String msg}) {
  return (Padding(
    padding: const EdgeInsets.only(
      left: 32,
      right: 32,
      top: 16,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF19191a),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatarWidget(
            imgUrl: imgUrl,
            size: 42,
            hasBorder: false,
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF666970),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  msg,
                  style: const TextStyle(
                    color: Color(0xFFa8a9ad),
                    height: 1.4,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  ));
}

Widget chatMessageListWidget() {
  return (Column(
    children: [
      chatMessageWidget(
        date: "Oct 22 8:45 AM",
        imgUrl:
        "https://images.pexels.com/photos/1438275/pexels-photo-1438275.jpeg?auto=compress&cs=tinysrgb&crop=faces&fit=crop&h=200&w=200",
        msg:
        "🔥 Man bun skateboard organic bicycle rights, put a bird on it tote bag chillwave asymmetrical banh mi cardigan shaman ennui four dollar toast craft beer. ",
        username: "Scott",
      ),
      chatMessageWidget(
        date: "Oct 22 2:45 AM",
        imgUrl:
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=046c29138c1335ef8edee7daf521ba50",
        msg:
        "Offal blog literally bitters, leggings beard mumblecore godard tousled 🍒",
        username: "Phoebe",
      ),
      chatMessageWidget(
        date: "Oct 22 2:45 AM",
        imgUrl:
        "https://images.unsplash.com/photo-1549068106-b024baf5062d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ",
        msg:
        "Forage selfies neutra, pop-up photo booth farm-to-table drinking vinegar chillwave ramps meditation asymmetrical. Tattooed jean shorts quinoa tacos snackwave.",
        username: "Mathius",
      ),
      chatMessageWidget(
        date: "Oct 22 2:15 AM",
        imgUrl:
        "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ",
        msg: "Thank you guys 🤙",
        username: "Rose",
      ),
      chatMessageWidget(
        date: "Oct 22 8:45 AM",
        imgUrl:
        "https://images.pexels.com/photos/1438275/pexels-photo-1438275.jpeg?auto=compress&cs=tinysrgb&crop=faces&fit=crop&h=200&w=200",
        msg:
        "🔥 Man bun skateboard organic bicycle rights, put a bird on it tote bag chillwave asymmetrical banh mi cardigan shaman ennui four dollar toast craft beer. ",
        username: "Scott",
      ),
      chatMessageWidget(
        date: "Oct 22 2:45 AM",
        imgUrl:
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=046c29138c1335ef8edee7daf521ba50",
        msg:
        "Offal blog literally bitters, leggings beard mumblecore godard tousled 🍒",
        username: "Phoebe",
      ),
      chatMessageWidget(
        date: "Oct 22 2:45 AM",
        imgUrl:
        "https://images.unsplash.com/photo-1549068106-b024baf5062d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ",
        msg:
        "Forage selfies neutra, pop-up photo booth farm-to-table drinking vinegar chillwave ramps meditation asymmetrical. Tattooed jean shorts quinoa tacos snackwave.",
        username: "Mathius",
      ),
      chatMessageWidget(
        date: "Oct 22 2:15 AM",
        imgUrl:
        "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ",
        msg: "Thank you guys 🤙",
        username: "Rose",
      ),
    ],
  ));
}
