import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/loader_widget.dart';
import 'package:pawlly/screens/home/event/event_controller.dart';
import 'package:pawlly/main.dart';
import '../../../components/app_scaffold.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'event_item_component.dart';

class EventListScreen extends StatelessWidget {
  EventListScreen({Key? key}) : super(key: key);
  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.upcomingEvents,
      isLoading: eventController.isLoading,
      body: Obx(() => SnapHelperWidget(
          future: eventController.getEvents.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                eventController.page(1);
                eventController.isLoading(true);
                eventController.init();
              },
            ).paddingSymmetric(horizontal: 16);
          },
          loadingWidget: const LoaderWidget(),
          onSuccess: (events) {
            return AnimatedListView(
              shrinkWrap: true,
              itemCount: events.length,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              emptyWidget: NoDataWidget(
                title: locale.value.noEventsFound,
                imageWidget: const EmptyStateWidget(),
                subTitle: locale.value.thereAreNoEvents,
                retryText: locale.value.reload,
                onRetry: () {
                  eventController.page(1);
                  eventController.isLoading(true);
                  eventController.init();
                },
              ).paddingSymmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return EventItemComponent(
                  event: events[index],
                  youMayAlsoLikeEvent: events,
                ).paddingSymmetric(vertical: 8);
              },
              onNextPage: () async {
                if (!eventController.isLastPage.value) {
                  eventController.page(eventController.page.value + 1);
                  eventController.isLoading(true);
                  eventController.init();
                  return await Future.delayed(const Duration(seconds: 2), () {
                    eventController.isLoading(false);
                  });
                }
              },
              onSwipeRefresh: () async {
                eventController.page(1);
                eventController.init();
                return await Future.delayed(const Duration(seconds: 2));
              },
            );
          })),
    );
  }
}
