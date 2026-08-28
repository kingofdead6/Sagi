import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/models/image_ref.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/network/api_exception.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/result.dart';

/// Which Cloudinary folder an upload lands in. The server maps these onto
/// `saji/<folder>` and rejects anything it does not recognise.
enum UploadFolder { vendors, products, offers, avatars }

/// Picks an image and hands it to the API, which is the only party holding the
/// Cloudinary secret. Bytes are read rather than a `File` path so the same code
/// works on the admin web build, where there is no filesystem.
class ImageUploadService {
  ImageUploadService(this._client, {ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ApiClient _client;

  /// Injectable so tests can supply a fake instead of the platform picker.
  final ImagePicker _picker;

  /// Returns `null` when the user dismisses the picker without choosing.
  Future<XFile?> pick({ImageSource source = ImageSource.gallery}) => _picker.pickImage(
        source: source,
        // Cloudinary re-encodes anyway; capping here keeps the upload small on
        // the mobile connections this app is built for.
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
      );

  /// Uploads [file] and returns the stored asset.
  ///
  /// [replaces] is the `publicId` of an image being swapped out — the server
  /// deletes it on success so replaced assets do not accumulate.
  Future<Result<ImageRef>> upload(
    XFile file, {
    required UploadFolder folder,
    String? replaces,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final form = FormData.fromMap({
        'folder': folder.name,
        if (replaces != null) 'replacesPublicId': replaces,
        'image': MultipartFile.fromBytes(
          bytes,
          filename: _filename(file),
          // Without an explicit type this goes up as octet-stream, which the
          // server's mime filter rejects.
          contentType: MediaType.parse(_mimeType(file)),
        ),
      });

      final response = await _client.raw.post<dynamic>(
        Api.uploadImage,
        data: form,
        onSendProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent / total);
        },
      );

      final body = response.data;
      final payload = body is Map<String, dynamic> ? body['data'] : body;
      return Result.ok(ImageRef.fromJson(Map<String, dynamic>.from(payload as Map)));
    } on DioException catch (error) {
      return Result.err(ApiErrorMapper.fromDio(error));
    } catch (error) {
      return Result.err(Failure.unknown(error.toString()));
    }
  }

  /// Multer needs a name with a usable extension to infer the mime type; the
  /// web picker sometimes hands back an empty one.
  String _filename(XFile file) {
    final name = file.name.trim();
    if (name.contains('.')) return name;
    return 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  /// The server only accepts jpeg, png, webp and gif. `XFile.mimeType` is null
  /// on some Android pickers, so fall back to the extension.
  String _mimeType(XFile file) {
    final declared = file.mimeType;
    if (declared != null && declared.startsWith('image/')) return declared;

    return switch (_filename(file).toLowerCase().split('.').last) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
  }
}
