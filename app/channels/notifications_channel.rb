# frozen_string_literal: true

# Canal de notificações em tempo real
# Permite que clientes se inscrevam e recebam notificações de eventos do sistema
# Suporta diferenciação por tipo de dispositivo (web, mobile, tablet)
class NotificationsChannel < ApplicationCable::Channel
  # Chamado quando um cliente se inscreve no canal
  def subscribed
    # Extrair parâmetros da subscrição
    device_type = params[:device_type] || "unknown"
    device_id = params[:device_id] || generate_device_id
    user_id = params[:user_id] # Opcional - para quando implementar autenticação

    # Armazenar informações do cliente
    @device_type = device_type
    @device_id = device_id
    @user_id = user_id

    # Stream 1: Canal geral - TODAS as notificações
    stream_from "notifications"

    # Stream 2: Canal específico por tipo de dispositivo (web, mobile, tablet)
    stream_from "notifications:#{device_type}"

    # Stream 3: Canal específico por dispositivo individual (para notificações direcionadas)
    stream_from "notifications:device:#{device_id}"

    # Stream 4 (Opcional): Canal específico por usuário (quando implementar autenticação)
    stream_from "notifications:user:#{user_id}" if user_id.present?

    # Log de conexão detalhado
    Rails.logger.info "[NotificationsChannel] Cliente inscrito - Device: #{device_type}, ID: #{device_id}, User: #{user_id || 'anônimo'}"

    # Enviar mensagem de boas-vindas personalizada
    transmit({
      type: "connection_established",
      message: "Conectado ao canal de notificações",
      device_info: {
        device_type: device_type,
        device_id: device_id,
        user_id: user_id,
        subscribed_channels: [
          "notifications",
          "notifications:#{device_type}",
          "notifications:device:#{device_id}",
          (user_id ? "notifications:user:#{user_id}" : nil)
        ].compact
      },
      timestamp: Time.current.iso8601
    })
  end

  # Chamado quando um cliente se desinscreve do canal
  def unsubscribed
    # Log de desconexão
    Rails.logger.info "[NotificationsChannel] Cliente desinscrito - Device: #{@device_type}, ID: #{@device_id}"
  end

  # Método: permite que clientes enviem mensagens pelo canal (ping/pong)
  def ping(data)
    transmit({
      type: "pong",
      message: "Servidor ativo",
      device_info: {
        device_type: @device_type,
        device_id: @device_id,
        user_id: @user_id
      },
      received_data: data,
      timestamp: Time.current.iso8601
    })
  end

  # Método: atualizar informações do dispositivo (ex: mudar de mobile para tablet)
  def update_device_info(data)
    new_device_type = data["device_type"]

    if new_device_type.present? && new_device_type != @device_type
      # Desinscrever do canal antigo
      stop_stream_from "notifications:#{@device_type}"

      # Atualizar device_type
      @device_type = new_device_type

      # Inscrever no novo canal
      stream_from "notifications:#{@device_type}"

      Rails.logger.info "[NotificationsChannel] Device type atualizado para: #{@device_type}"

      transmit({
        type: "device_type_updated",
        message: "Tipo de dispositivo atualizado",
        new_device_type: @device_type,
        timestamp: Time.current.iso8601
      })
    end
  end

  private

  # Gera um ID único para o dispositivo
  def generate_device_id
    SecureRandom.uuid
  end
end
