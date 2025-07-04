import 'package:flutter/material.dart';
import '../objects/sync_service.dart';
import '../popups/popup_handler.dart';
import '../popups/update_popup.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({super.key});

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  bool isTextToSpeechOn = true;
  String selectedTextSize = "Large";
  bool enableAutoUpdates = true;
  bool notifyUpdates = false;

  Future <void> _checkUpdates() async{
    bool availableUpdates = await SyncService.instance.hasPendingUpdates();
    if(availableUpdates){
      PopupHandler.instance.showPopup(context, const UpdatePopup());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.9),
            child: SingleChildScrollView(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: const [
                        Icon(Icons.settings, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Settings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Text-To-Speech with toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Text-To-Speech", style: TextStyle(color: Colors.white)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isTextToSpeechOn = !isTextToSpeechOn;
                            });
                          },
                          child: Icon(
                            isTextToSpeechOn ? Icons.toggle_on : Icons.toggle_off,
                            size: 40,
                            color: isTextToSpeechOn ? Colors.greenAccent : Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // On-Screen Text Size
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("On Screen Text Size", style: TextStyle(color: Colors.white)),
                        Container(
                          height: 30,
                          width: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.white, 
                              ),
                              child: DropdownButton<String>(
                                value: selectedTextSize,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTextSize = value!;
                                  });
                                },
                                iconEnabledColor: Colors.black,
                                style: const TextStyle(color: Colors.black),
                                items: const [
                                  DropdownMenuItem(value: "Small", child: Text("Small")),
                                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                                  DropdownMenuItem(value: "Large", child: Text("Large")),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Reset App Preferences
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("On Screen Text Size", style: TextStyle(color: Colors.white)),
                        Container(
                          height: 30,
                          width: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.white,
                              ),
                              child: DropdownButton<String>(
                                value: selectedTextSize,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTextSize = value!;
                                  });
                                },
                                iconEnabledColor: const Color.fromARGB(255, 0, 0, 0),
                                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                items: const [
                                  DropdownMenuItem(value: "Small", child: Text("Small")),
                                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                                  DropdownMenuItem(value: "Large", child: Text("Large")),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Check for Updates Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row with Check Button and "Check for Updates" text
                          Row(
                            children: [ 
                              const Expanded(
                                child: Text(
                                  "Check for Updates",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              // Check Button
                              Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    _checkUpdates();
                                  },
                                  icon: Icon(Icons.system_update, color: Colors.black, size: 20),
                                  label: Text(
                                    "Check",
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Application Version
                          const Text(
                            "Application Version 1.0.0",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),

                      // Reset App Preferences
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Text(
                              "Reset App Preferences",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink[600],
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Reset", style: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                      "Warning: This will delete your saved\npreferences",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),

                      const SizedBox(height: 24),



                    // Close & Quit App buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Close"),
                          ),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              // Exit app logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Quit App"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
