import 'package:flutter/material.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/features/sales_management/product_efficiency/model/product_efficiency_model.dart';

class ProductEfficiencyPage extends StatefulWidget {
  final ProductEfficiencyModel model;
  const ProductEfficiencyPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<ProductEfficiencyPage> createState() => _ProductEfficiencyPageState();
}

class _ProductEfficiencyPageState extends State<ProductEfficiencyPage> {
  final _typeController = TextEditingController();
  final _productController = TextEditingController();
  final _glossController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _baseController = TextEditingController();
  final _easeOfDilutionController = TextEditingController();
  final _easeOfApplicationController = TextEditingController();
  final _numberOfCoatsController = TextEditingController();
  final _smoothnessController = TextEditingController();
  final _whitenessController = TextEditingController();
  final _opacityController = TextEditingController();
  final _totalOpacityController = TextEditingController();
  final _glossScrubRatioController = TextEditingController();
  final _coveragePerLiterController = TextEditingController();
  final _coveragePerKgController = TextEditingController();
  final _efficiencyLevelController = TextEditingController();
  final _pricePerLiterController = TextEditingController();
  final _efficiencyPriceRatioController = TextEditingController();
  final _technicalNotesController = TextEditingController();
  final _salesNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final model = widget.model;

    _typeController.text = model.type ?? '';
    _productController.text = model.product ?? '';
    _glossController.text = model.gloss ?? '';
    _manufacturerController.text = model.manufacturer ?? '';
    _baseController.text = model.base ?? '';
    _easeOfDilutionController.text = model.ease_of_dilution?.toString() ?? '';
    _easeOfApplicationController.text =
        model.ease_of_application?.toString() ?? '';
    _numberOfCoatsController.text = model.number_of_coats?.toString() ?? '';
    _smoothnessController.text = model.smoothness?.toString() ?? '';
    _whitenessController.text = model.whiteness?.toString() ?? '';
    _opacityController.text = model.opacity?.toString() ?? '';
    _totalOpacityController.text = model.total_opacity?.toString() ?? '';
    _glossScrubRatioController.text = model.gloss_scrub_ratio?.toString() ?? '';
    _coveragePerLiterController.text =
        model.coverage_per_liter?.toString() ?? '';
    _coveragePerKgController.text = model.coverage_per_kg?.toString() ?? '';
    _efficiencyLevelController.text = model.efficiency_level?.toString() ?? '';
    _pricePerLiterController.text = model.price_per_liter?.toString() ?? '';
    _efficiencyPriceRatioController.text =
        model.efficiency_price_ratio?.toString() ?? '';
    _technicalNotesController.text = model.technical_notes ?? '';
    _salesNotesController.text = model.sales_notes ?? '';
  }

  @override
  void dispose() {
    _typeController.dispose();
    _productController.dispose();
    _glossController.dispose();
    _manufacturerController.dispose();
    _baseController.dispose();
    _easeOfDilutionController.dispose();
    _easeOfApplicationController.dispose();
    _numberOfCoatsController.dispose();
    _smoothnessController.dispose();
    _whitenessController.dispose();
    _opacityController.dispose();
    _totalOpacityController.dispose();
    _glossScrubRatioController.dispose();
    _coveragePerLiterController.dispose();
    _coveragePerKgController.dispose();
    _efficiencyLevelController.dispose();
    _pricePerLiterController.dispose();
    _efficiencyPriceRatioController.dispose();
    _technicalNotesController.dispose();
    _salesNotesController.dispose();
    super.dispose();
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.model.product ?? '')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildSection(
                  title: 'معلومات المنتج',
                  children: [
                    MyTextField(
                      controller: _typeController,
                      labelText: 'النوع',
                    ),
                    MyTextField(
                      controller: _productController,
                      labelText: 'المنتج',
                    ),
                    MyTextField(
                      controller: _glossController,
                      labelText: 'اللمعة',
                    ),
                    MyTextField(
                      controller: _manufacturerController,
                      labelText: 'الشركة المصنعة',
                    ),
                    MyTextField(
                      controller: _baseController,
                      labelText: 'الأساس',
                    ),
                  ],
                ),
                _buildSection(
                  title: 'سهولة وخصائص الأداء',
                  children: [
                    RatingIndicatorBar(
                        label: 'سهولة الحل',
                        value:
                            double.tryParse(_easeOfDilutionController.text) ??
                                0),
                    RatingIndicatorBar(
                        label: 'سهولة المد',
                        value: double.tryParse(
                                _easeOfApplicationController.text) ??
                            0),
                    RatingIndicatorBar(
                        label: 'نعومة وانسيابية',
                        value:
                            double.tryParse(_smoothnessController.text) ?? 0),
                    RatingIndicatorBar(
                        label: 'البياض',
                        value: double.tryParse(_whitenessController.text) ?? 0),
                  ],
                ),
                _buildSection(
                  title: 'البيانات الفنية',
                  children: [
                    MyTextField(
                        controller: _numberOfCoatsController,
                        labelText: 'عدد الأوجه'),
                    MyTextField(
                      controller: _numberOfCoatsController,
                      labelText: 'عدد الأوجه',
                    ),
                    MyTextField(
                      controller: _opacityController,
                      labelText: 'السترية',
                    ),
                    MyTextField(
                      controller: _totalOpacityController,
                      labelText: 'محصلة السترية',
                    ),
                    MyTextField(
                      controller: _glossScrubRatioController,
                      labelText: 'اللمعان /قوة الحك',
                    ),
                    MyTextField(
                      controller: _coveragePerLiterController,
                      labelText: 'معدل الفرد م2/ل',
                    ),
                    MyTextField(
                      controller: _coveragePerKgController,
                      labelText: 'معدل الفرد م2/كغ',
                    ),
                    MyTextField(
                      controller: _efficiencyLevelController,
                      labelText: 'درجة كفاءة المنتج',
                    ),
                    MyTextField(
                      controller: _pricePerLiterController,
                      labelText: 'سعر الليتر',
                    ),
                    MyTextField(
                      controller: _efficiencyPriceRatioController,
                      labelText: 'نسبة الكفاءة على السعر',
                    ),
                  ],
                ),
                _buildSection(
                  title: 'ملاحظات',
                  children: [
                    MyTextField(
                      controller: _technicalNotesController,
                      labelText: 'ملاحظات دعم فني',
                    ),
                    MyTextField(
                      controller: _salesNotesController,
                      labelText: 'ملاحظات مبيعات',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingIndicatorBar extends StatefulWidget {
  final String label;
  final double value; // value between 1 and 10

  const RatingIndicatorBar({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  State<RatingIndicatorBar> createState() => _RatingIndicatorBarState();
}

class _RatingIndicatorBarState extends State<RatingIndicatorBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Duration _duration = const Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _animation = Tween<double>(begin: 0, end: widget.value.clamp(0, 10))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant RatingIndicatorBar oldWidget) {
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: 0, end: widget.value.clamp(0, 10))
          .animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barWidth = MediaQuery.of(context).size.width - 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  height: 20,
                  width: barWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 20,
                  width: (_animation.value / 10) * barWidth,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.yellow, Colors.green],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.value.toStringAsFixed(1)} / 10',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Icon(
              widget.value >= 8
                  ? Icons.sentiment_very_satisfied
                  : widget.value >= 5
                      ? Icons.sentiment_satisfied
                      : Icons.sentiment_dissatisfied,
              color: widget.value >= 8
                  ? Colors.green
                  : widget.value >= 5
                      ? Colors.orange
                      : Colors.red,
              size: 18,
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
