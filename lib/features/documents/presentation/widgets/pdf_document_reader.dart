import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';

/// In-app PDF reader with desktop-friendly navigation and zoom controls.
class PdfDocumentReader extends StatefulWidget {
  const PdfDocumentReader({
    required this.filePath,
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final String filePath;
  final EdgeInsets padding;

  @override
  State<PdfDocumentReader> createState() => _PdfDocumentReaderState();
}

class _PdfDocumentReaderState extends State<PdfDocumentReader> {
  late final PdfViewerController _controller;
  final TextEditingController _pageField = TextEditingController();
  var _ready = false;
  int _pageNumber = 1;
  int _pageCount = 1;
  double _zoom = 1;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _pageField.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PdfDocumentReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      setState(() {
        _ready = false;
        _pageNumber = 1;
        _pageCount = 1;
        _zoom = 1;
      });
      _pageField.text = '1';
    }
  }

  void _onControllerChanged() {
    if (!_controller.isReady || !mounted) return;
    final page = _controller.pageNumber ?? _pageNumber;
    final count = _controller.pageCount;
    final zoom = _controller.currentZoom;
    if (page == _pageNumber &&
        count == _pageCount &&
        (zoom - _zoom).abs() < 0.001) {
      return;
    }
    setState(() {
      _ready = true;
      _pageNumber = page;
      _pageCount = count;
      _zoom = zoom;
    });
    if (_pageField.text != '$page') {
      _pageField.text = '$page';
    }
  }

  Future<void> _goToPage(int page) async {
    if (!_controller.isReady) return;
    final target = page.clamp(1, _controller.pageCount);
    await _controller.goToPage(pageNumber: target);
  }

  Future<void> _submitPageField() async {
    final parsed = int.tryParse(_pageField.text.trim());
    if (parsed == null) {
      _pageField.text = '$_pageNumber';
      return;
    }
    await _goToPage(parsed);
  }

  static const _minZoom = 0.25;
  static const _maxZoom = 8.0;
  static const _zoomStep = 0.25;

  Future<void> _setZoomPercent(double zoom) async {
    if (!_controller.isReady) return;
    final clamped = zoom.clamp(_minZoom, _maxZoom);
    await _controller.setZoom(_controller.centerPosition, clamped);
  }

  Future<void> _zoomIn() async {
    if (!_controller.isReady) return;
    // Snap to nearest 25% step, then go one step up.
    final current = _controller.currentZoom;
    final stepped = ((current / _zoomStep).round() * _zoomStep) + _zoomStep;
    await _setZoomPercent(stepped);
  }

  Future<void> _zoomOut() async {
    if (!_controller.isReady) return;
    final current = _controller.currentZoom;
    final stepped = ((current / _zoomStep).round() * _zoomStep) - _zoomStep;
    await _setZoomPercent(stepped);
  }

  Future<void> _fitWidth() async {
    if (!_controller.isReady) return;
    final page = _controller.pageNumber ?? 1;
    final fits = _controller.calcFitZoomMatrices();
    if (fits.isNotEmpty) {
      await _controller.goTo(fits.first.matrix);
      return;
    }
    final zoom = _controller.alternativeFitScale ?? _controller.coverScale;
    await _setZoomPercent(zoom);
    await _controller.goToPage(pageNumber: page);
  }

  Future<void> _fitPage() async {
    if (!_controller.isReady) return;
    final page = _controller.pageNumber ?? 1;
    await _controller.goTo(
      _controller.calcMatrixForPage(
        pageNumber: page,
        anchor: PdfPageAnchor.all,
      ),
    );
  }

  Future<void> _resetZoom() async {
    await _setZoomPercent(1.0);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PdfToolbar(
            enabled: _ready,
            pageNumber: _pageNumber,
            pageCount: _pageCount,
            zoom: _zoom,
            pageField: _pageField,
            onFirst: () => _goToPage(1),
            onPrevious: () => _goToPage(_pageNumber - 1),
            onNext: () => _goToPage(_pageNumber + 1),
            onLast: () => _goToPage(_pageCount),
            onSubmitPage: _submitPageField,
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onFitWidth: _fitWidth,
            onFitPage: _fitPage,
            onResetZoom: _resetZoom,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ColoredBox(
                color: scheme.surfaceContainerHighest,
                child: PdfViewer.file(
                  widget.filePath,
                  key: ValueKey(widget.filePath),
                  controller: _controller,
                  params: PdfViewerParams(
                    backgroundColor: scheme.surfaceContainerHighest,
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.25,
                    maxScale: 8,
                    useAlternativeFitScaleAsMinScale: false,
                    scrollByMouseWheel: 0.25,
                    enableKeyboardNavigation: true,
                    margin: 12,
                    calculateInitialZoom:
                        (document, controller, fitZoom, coverZoom) => 1.0,
                    loadingBannerBuilder:
                        (context, bytesDownloaded, totalBytes) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 12),
                            Text(
                              'Loading PDF…',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      );
                    },
                    errorBannerBuilder:
                        (context, error, stackTrace, documentRef) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.picture_as_pdf_outlined,
                                  size: 48, color: scheme.error),
                              const SizedBox(height: 12),
                              Text(
                                'Could not open PDF',
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$error',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    onViewerReady: (document, controller) {
                      if (!mounted) return;
                      setState(() {
                        _ready = true;
                        _pageCount = document.pages.length;
                        _pageNumber = controller.pageNumber ?? 1;
                        _zoom = controller.currentZoom;
                      });
                      _pageField.text = '$_pageNumber';
                    },
                    onPageChanged: (pageNumber) {
                      if (!mounted || pageNumber == null) return;
                      setState(() => _pageNumber = pageNumber);
                      if (_pageField.text != '$pageNumber') {
                        _pageField.text = '$pageNumber';
                      }
                    },
                    viewerOverlayBuilder: (context, size, handleLinkTap) => [
                      PdfViewerScrollThumb(
                        controller: _controller,
                        thumbSize: const Size(10, 48),
                        thumbBuilder:
                            (context, thumbSize, pageNumber, controller) {
                          return Container(
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                      PdfViewerScrollThumb(
                        controller: _controller,
                        orientation: ScrollbarOrientation.bottom,
                        thumbSize: const Size(48, 10),
                        thumbBuilder:
                            (context, thumbSize, pageNumber, controller) {
                          return Container(
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfToolbar extends StatelessWidget {
  const _PdfToolbar({
    required this.enabled,
    required this.pageNumber,
    required this.pageCount,
    required this.zoom,
    required this.pageField,
    required this.onFirst,
    required this.onPrevious,
    required this.onNext,
    required this.onLast,
    required this.onSubmitPage,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFitWidth,
    required this.onFitPage,
    required this.onResetZoom,
  });

  final bool enabled;
  final int pageNumber;
  final int pageCount;
  final double zoom;
  final TextEditingController pageField;
  final VoidCallback onFirst;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onLast;
  final VoidCallback onSubmitPage;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onFitWidth;
  final VoidCallback onFitPage;
  final VoidCallback onResetZoom;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final zoomPercent = (zoom * 100).round();

    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 2,
          runSpacing: 4,
          children: [
            IconButton(
              tooltip: 'First page',
              onPressed: enabled && pageNumber > 1 ? onFirst : null,
              icon: const Icon(Icons.first_page_rounded),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: 'Previous page',
              onPressed: enabled && pageNumber > 1 ? onPrevious : null,
              icon: const Icon(Icons.chevron_left_rounded),
              visualDensity: VisualDensity.compact,
            ),
            SizedBox(
              width: 52,
              child: TextField(
                controller: pageField,
                enabled: enabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => onSubmitPage(),
                onEditingComplete: onSubmitPage,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '/ $pageCount',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
            IconButton(
              tooltip: 'Next page',
              onPressed: enabled && pageNumber < pageCount ? onNext : null,
              icon: const Icon(Icons.chevron_right_rounded),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: 'Last page',
              onPressed: enabled && pageNumber < pageCount ? onLast : null,
              icon: const Icon(Icons.last_page_rounded),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Zoom out',
              onPressed: enabled ? onZoomOut : null,
              icon: const Icon(Icons.zoom_out_rounded),
              visualDensity: VisualDensity.compact,
            ),
            TextButton(
              onPressed: enabled ? onResetZoom : null,
              child: Text('$zoomPercent%'),
            ),
            IconButton(
              tooltip: 'Zoom in',
              onPressed: enabled ? onZoomIn : null,
              icon: const Icon(Icons.zoom_in_rounded),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: 'Fit width',
              onPressed: enabled ? onFitWidth : null,
              icon: const Icon(Icons.fit_screen_outlined),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: 'Fit page',
              onPressed: enabled ? onFitPage : null,
              icon: const Icon(Icons.fullscreen_rounded),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
