import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/create_service_details/create_service_details_image_slider.dart';
import 'package:service_la/view/screens/create_service/controller/create_service_details_controller.dart';
import 'package:service_la/view/widgets/create_service_details/create_service_details_details_section.dart';
import 'package:service_la/view/widgets/create_service_details/create_service_details_reviews_section.dart';
import 'package:service_la/view/widgets/create_service_details/create_service_details_provider_profile_section.dart';

class CreateServiceDetailsScreen extends GetWidget<CreateServiceDetailsController> {
  const CreateServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.isLoadingServicesDetails.value
            ? const CustomProgressBar()
            : ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  CreateServiceDetailsImageSlider(),
                  CreateServiceDetailsDetailsSection(),
                  CreateServiceDetailsProviderProfileSection(),
                  CreateServiceDetailsReviewsSection(),
                ],
              ),
      ),
    );
  }
}
