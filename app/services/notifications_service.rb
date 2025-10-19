# frozen_string_literal: true

# Serviço responsável por gerenciar o envio de notificações via Action Cable
# Centraliza a lógica de broadcast e formatação de mensagens
class NotificationsService
  # Tipos de notificações suportados
  NOTIFICATION_TYPES = {
    ocorrencia_criada: "ocorrencia_criada",
    ocorrencia_atualizada: "ocorrencia_atualizada",
    ocorrencia_finalizada: "ocorrencia_finalizada",
    ocorrencia_removida: "ocorrencia_removida",
    sistema: "sistema"
  }.freeze

  # Broadcast de criação de ocorrência
  # @param ocorrencia [Ocorrencia] A ocorrência criada
  def self.broadcast_ocorrencia_criada(ocorrencia)
    payload = {
      type: NOTIFICATION_TYPES[:ocorrencia_criada],
      title: "Nova Ocorrência Registrada",
      message: "Ocorrência ##{ocorrencia.numero_bo} foi registrada",
      data: {
        id: ocorrencia.id_ocorrencia,
        numero_bo: ocorrencia.numero_bo,
        status: ocorrencia.status_ocorrencia,
        tipo_crime_id: ocorrencia.id_tipo_crime,
        bairro_id: ocorrencia.id_bairro,
        data_ocorrencia: ocorrencia.data_ocorrencia,
        latitude: ocorrencia.latitude_ocorrencia,
        longitude: ocorrencia.longitude_ocorrencia
      },
      timestamp: Time.current.iso8601
    }

    broadcast(payload)
    Rails.logger.info "[NotificationsService] Notificação enviada: ocorrencia_criada ##{ocorrencia.id_ocorrencia}"
  end

  # Broadcast de atualização de ocorrência
  # @param ocorrencia [Ocorrencia] A ocorrência atualizada
  # @param changes [Hash] Mudanças realizadas
  def self.broadcast_ocorrencia_atualizada(ocorrencia, changes = {})
    payload = {
      type: NOTIFICATION_TYPES[:ocorrencia_atualizada],
      title: "Ocorrência Atualizada",
      message: "Ocorrência ##{ocorrencia.numero_bo} foi atualizada",
      data: {
        id: ocorrencia.id_ocorrencia,
        numero_bo: ocorrencia.numero_bo,
        status: ocorrencia.status_ocorrencia,
        changes: changes
      },
      timestamp: Time.current.iso8601
    }

    broadcast(payload)
    Rails.logger.info "[NotificationsService] Notificação enviada: ocorrencia_atualizada ##{ocorrencia.id_ocorrencia}"
  end

  # Broadcast de finalização de ocorrência
  # @param ocorrencia [Ocorrencia] A ocorrência finalizada
  def self.broadcast_ocorrencia_finalizada(ocorrencia)
    payload = {
      type: NOTIFICATION_TYPES[:ocorrencia_finalizada],
      title: "Ocorrência Finalizada",
      message: "Ocorrência ##{ocorrencia.numero_bo} foi marcada como Resolvida",
      data: {
        id: ocorrencia.id_ocorrencia,
        numero_bo: ocorrencia.numero_bo,
        status: ocorrencia.status_ocorrencia,
        data_ocorrencia: ocorrencia.data_ocorrencia
      },
      timestamp: Time.current.iso8601
    }

    broadcast(payload)
    Rails.logger.info "[NotificationsService] Notificação enviada: ocorrencia_finalizada ##{ocorrencia.id_ocorrencia}"
  end

  # Broadcast de remoção de ocorrência
  # @param ocorrencia_id [Integer] ID da ocorrência removida
  # @param numero_bo [String] Número do BO
  def self.broadcast_ocorrencia_removida(ocorrencia_id, numero_bo)
    payload = {
      type: NOTIFICATION_TYPES[:ocorrencia_removida],
      title: "Ocorrência Removida",
      message: "Ocorrência ##{numero_bo} foi removida do sistema",
      data: {
        id: ocorrencia_id,
        numero_bo: numero_bo
      },
      timestamp: Time.current.iso8601
    }

    broadcast(payload)
    Rails.logger.info "[NotificationsService] Notificação enviada: ocorrencia_removida ##{ocorrencia_id}"
  end

  # Broadcast de notificação customizada
  # @param type [Symbol] Tipo da notificação
  # @param title [String] Título da notificação
  # @param message [String] Mensagem
  # @param data [Hash] Dados adicionais
  def self.broadcast_custom(type:, title:, message:, data: {})
    payload = {
      type: type.to_s,
      title: title,
      message: message,
      data: data,
      timestamp: Time.current.iso8601
    }

    broadcast(payload)
    Rails.logger.info "[NotificationsService] Notificação customizada enviada: #{type}"
  end

  # Broadcast de notificação de sistema
  # @param message [String] Mensagem do sistema
  # @param level [String] Nível: info, warning, error
  def self.broadcast_sistema(message:, level: "info", data: {})
    payload = {
      type: NOTIFICATION_TYPES[:sistema],
      title: "Notificação do Sistema",
      message: message,
      level: level,
      data: data,
      timestamp: Time.current.iso8601
    }

    broadcast(payload)
    Rails.logger.info "[NotificationsService] Notificação de sistema enviada: #{level} - #{message}"
  end

  # Broadcast para dispositivos específicos
  # @param device_types [Array<String>] Lista de tipos de dispositivos: ["web", "mobile", "tablet"]
  # @param type [Symbol] Tipo da notificação
  # @param title [String] Título
  # @param message [String] Mensagem
  # @param data [Hash] Dados adicionais
  def self.broadcast_to_devices(device_types:, type:, title:, message:, data: {})
    payload = {
      type: type.to_s,
      title: title,
      message: message,
      data: data,
      target_devices: device_types,
      timestamp: Time.current.iso8601
    }

    # Enviar para cada tipo de dispositivo
    device_types.each do |device_type|
      ActionCable.server.broadcast("notifications:#{device_type}", payload)
      Rails.logger.info "[NotificationsService] Notificação enviada para dispositivos: #{device_type}"
    end
  end

  # Broadcast apenas para dispositivos WEB
  def self.broadcast_to_web(type:, title:, message:, data: {})
    broadcast_to_devices(
      device_types: ["web"],
      type: type,
      title: title,
      message: message,
      data: data
    )
  end

  # Broadcast apenas para dispositivos MOBILE
  def self.broadcast_to_mobile(type:, title:, message:, data: {})
    broadcast_to_devices(
      device_types: ["mobile"],
      type: type,
      title: title,
      message: message,
      data: data
    )
  end

  # Broadcast para dispositivo específico por ID
  # @param device_id [String] ID único do dispositivo
  # @param type [Symbol] Tipo da notificação
  # @param title [String] Título
  # @param message [String] Mensagem
  # @param data [Hash] Dados adicionais
  def self.broadcast_to_device_id(device_id:, type:, title:, message:, data: {})
    payload = {
      type: type.to_s,
      title: title,
      message: message,
      data: data,
      target_device_id: device_id,
      timestamp: Time.current.iso8601
    }

    ActionCable.server.broadcast("notifications:device:#{device_id}", payload)
    Rails.logger.info "[NotificationsService] Notificação enviada para device_id: #{device_id}"
  end

  # Broadcast para usuário específico (quando implementar autenticação)
  # @param user_id [Integer] ID do usuário
  # @param type [Symbol] Tipo da notificação
  # @param title [String] Título
  # @param message [String] Mensagem
  # @param data [Hash] Dados adicionais
  def self.broadcast_to_user(user_id:, type:, title:, message:, data: {})
    payload = {
      type: type.to_s,
      title: title,
      message: message,
      data: data,
      target_user_id: user_id,
      timestamp: Time.current.iso8601
    }

    ActionCable.server.broadcast("notifications:user:#{user_id}", payload)
    Rails.logger.info "[NotificationsService] Notificação enviada para user_id: #{user_id}"
  end

  private

  # Método interno para realizar o broadcast
  # @param payload [Hash] Dados a serem enviados
  # @param channel [String] Canal de destino (padrão: "notifications")
  def self.broadcast(payload, channel = "notifications")
    ActionCable.server.broadcast(channel, payload)
  end
end
