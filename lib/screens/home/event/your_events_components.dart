import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../dashboard/dashboard_res_model.dart';
import 'event_item_component.dart';

class YourEventsComponents extends StatelessWidget {
  final List<PetEvent> events;
  const YourEventsComponents({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        8.height,
        HorizontalList(
          runSpacing: 16,
          spacing: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return EventItemComponent(event: events[index], youMayAlsoLikeEvent: events, itemWidth: 300);
          },
        ),
      ],
    );
  }
}
