export type ApiErrorCode =
  | 'VALIDATION_ERROR'
  | 'UNAUTHORIZED'
  | 'FORBIDDEN'
  | 'NOT_FOUND'
  | 'CONFLICT'
  | 'ILLEGAL_TRANSITION'
  | 'RATE_LIMITED'
  | 'INTERNAL';

export class ApiError extends Error {
  readonly status: number;
  readonly code: ApiErrorCode;
  readonly details?: unknown;

  constructor(status: number, code: ApiErrorCode, message: string, details?: unknown) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code;
    this.details = details;
    Error.captureStackTrace?.(this, ApiError);
  }

  static badRequest(message = 'طلب غير صالح', details?: unknown) {
    return new ApiError(400, 'VALIDATION_ERROR', message, details);
  }
  static unauthorized(message = 'يجب تسجيل الدخول') {
    return new ApiError(401, 'UNAUTHORIZED', message);
  }
  static forbidden(message = 'غير مصرح لك بهذا الإجراء') {
    return new ApiError(403, 'FORBIDDEN', message);
  }
  static notFound(message = 'العنصر غير موجود') {
    return new ApiError(404, 'NOT_FOUND', message);
  }
  static conflict(message = 'تعارض في البيانات') {
    return new ApiError(409, 'CONFLICT', message);
  }
  static illegalTransition(message = 'تغيير الحالة غير مسموح') {
    return new ApiError(409, 'ILLEGAL_TRANSITION', message);
  }
  static internal(message = 'خطأ في الخادم') {
    return new ApiError(500, 'INTERNAL', message);
  }
}
