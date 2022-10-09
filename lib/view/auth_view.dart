import 'package:dca_flutter/config/app_state.dart';
import 'package:dca_flutter/widgets/button.dart';
import 'package:dca_flutter/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../config/app_config.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/ternary_container.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: SafeArea(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: viewModel.pageController,
            onPageChanged: (index) => viewModel.changePageIndex(index),
            children: [
              Column(
                children: [
                  const Text("Sync Account"),
                  Form(
                    key: viewModel.syncAccountFormKey,
                    child: DCATextFormField(
                      title: "Quidax Secret Key",
                      obscureText: true,
                      textEditingController: viewModel.secretKeyTextController,
                      validator: (String value) =>
                          value.isEmpty ? "A.P.I key is required boss" : null,
                    ),
                  ),
                  DCAButton(
                    child: DCATernary(
                      condition: viewModel.appState == AppState.loading,
                      trueWidget: const CircularProgressIndicator.adaptive(),
                      falseWidget: const Text(
                        "SYNC",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (viewModel.syncAccountFormKey.currentState!
                          .validate()) {
                        viewModel.handleSyncAccount(
                            viewModel.secretKeyTextController.text);
                      }
                    },
                    color: AppConfigService.hexToColor("#ffb300").withOpacity(
                      viewModel.appState == AppState.loading ? 0.5 : 1,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Enter OTP"),
                  Form(
                    key: viewModel.otpFormKey,
                    child: DCATextFormField(
                      title: "OTP",
                      textEditingController: viewModel.otpTextController,
                      validator: (String value) =>
                          value.isEmpty ? "OTP is required boss" : null,
                    ),
                  ),
                  DCAButton(
                    child: DCATernary(
                      condition: viewModel.appState == AppState.loading,
                      trueWidget: const CircularProgressIndicator.adaptive(),
                      falseWidget: const Text(
                        "LOG IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (viewModel.otpFormKey.currentState!.validate()) {
                        viewModel.authenticateAccount(
                            viewModel.otpTextController.text);
                      }
                    },
                    color: AppConfigService.hexToColor("#ffb300").withOpacity(
                      viewModel.appState == AppState.loading ? 0.5 : 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
