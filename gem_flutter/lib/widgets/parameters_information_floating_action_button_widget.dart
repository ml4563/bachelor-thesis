import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';

/// A floating action button widget that displays an information panel about ChatGPT parameters.
class ParametersInformationFloatingActionButtonWidget extends StatefulWidget {
  const ParametersInformationFloatingActionButtonWidget({super.key});

  @override
  ParametersInformationFloatingActionButtonWidgetState createState() =>
      ParametersInformationFloatingActionButtonWidgetState();
}

class ParametersInformationFloatingActionButtonWidgetState
    extends State<ParametersInformationFloatingActionButtonWidget> {
  /// Flag to track the visibility of the information panel.
  bool _isPanelVisible = false;

  /// Handle the visibility of the information panel.
  void _handleInformationPanel() {
    setState(() {
      _isPanelVisible = !_isPanelVisible;
    });
  }

  /// Builds a card widget displaying a label and its corresponding information text.
  Widget _buildCard({
    required String infolabel,
    required String infoText,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: GlobalVariables.smallPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              infolabel,
              style: theme.textTheme.titleSmall,
            ),
            GlobalVariables.smallVerticalSizedBox,
            Text(
              infoText,
              style: theme.textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a list of information cards with parameter labels and explanations.
  List<Widget> _buildInfoCards() {
    return [
      // Model
      _buildCard(
          infolabel: GlobalVariables.modelLabel,
          infoText: GlobalVariables.modelInfo),
      GlobalVariables.divider,
      // Content
      _buildCard(
          infolabel: GlobalVariables.systemMessageContentLabel,
          infoText: GlobalVariables.systemMessageContentInfo),
      GlobalVariables.divider,
      // Frequency_penalty
      _buildCard(
          infolabel: GlobalVariables.frequencyPenaltyLabel,
          infoText: GlobalVariables.frequencyPenaltyInfo),
      GlobalVariables.divider,
      // Presence_penalty
      _buildCard(
          infolabel: GlobalVariables.presencePenaltyLabel,
          infoText: GlobalVariables.presencePenaltyInfo),
      GlobalVariables.divider,
      // Temperature
      _buildCard(
          infolabel: GlobalVariables.temperatureLabel,
          infoText: GlobalVariables.temperatureInfo),
      GlobalVariables.divider,
      // Top_p
      _buildCard(
          infolabel: GlobalVariables.topPLabel,
          infoText: GlobalVariables.topPInfo),
      GlobalVariables.divider,
      // Max_token
      _buildCard(
          infolabel: GlobalVariables.maxTokensLabel,
          infoText: GlobalVariables.maxTokensInfo),
      GlobalVariables.divider,
      // Threshold_word
      _buildCard(
          infolabel: GlobalVariables.thresholdWordLabel,
          infoText: GlobalVariables.thresholdWordInfo),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        if (_isPanelVisible)
          Positioned(
            top: 50,
            right: 0,
            width: 300,
            height: MediaQuery.of(context).size.height - 100,
            child: Material(
              elevation: 5.0,
              color: theme.colorScheme.surface,
              child: Container(
                padding: GlobalVariables.mediumPadding,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          GlobalVariables.infoPanelTitle,
                          style: theme.textTheme.titleSmall,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: _handleInformationPanel,
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildInfoCards(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: _handleInformationPanel,
            backgroundColor: theme.colorScheme.secondary,
            tooltip: GlobalVariables.infoPanelTitle,
            child: Icon(
              Icons.info_outline_rounded,
              color: theme.colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
