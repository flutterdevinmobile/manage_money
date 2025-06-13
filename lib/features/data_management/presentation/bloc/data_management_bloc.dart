import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/usecases/create_backup_usecase.dart';
import '../../domain/usecases/export_data_usecase.dart';
import 'data_management_event.dart';
import 'data_management_state.dart';

class DataManagementBloc extends Bloc<DataManagementEvent, DataManagementState> {
  final CreateBackupUseCase createBackupUseCase;
  final ExportDataUseCase exportDataUseCase;

  DataManagementBloc({
    required this.createBackupUseCase,
    required this.exportDataUseCase,
  }) : super(DataManagementInitial()) {
    on<BackupCreateRequested>(_onBackupCreateRequested);
    on<DataExportRequested>(_onDataExportRequested);
  }

  Future<void> _onBackupCreateRequested(
    BackupCreateRequested event,
    Emitter<DataManagementState> emit,
  ) async {
    emit(DataManagementLoading());
    try {
      await createBackupUseCase(event.userId);
      emit(DataManagementSuccess(message: 'Ma\'lumotlar muvaffaqiyatli zaxiralandi'));
    } catch (e) {
      emit(DataManagementError(message: e.toString()));
    }
  }

  Future<void> _onDataExportRequested(
    DataExportRequested event,
    Emitter<DataManagementState> emit,
  ) async {
    emit(DataManagementLoading());
    try {
      final filePath = await exportDataUseCase(event.userId, event.dataType);
      
      // Share the file
      await Share.shareXFiles([XFile(filePath)]);
      
      emit(DataManagementSuccess(
        message: 'Ma\'lumotlar muvaffaqiyatli eksport qilindi',
        filePath: filePath,
      ));
    } catch (e) {
      emit(DataManagementError(message: e.toString()));
    }
  }
}
