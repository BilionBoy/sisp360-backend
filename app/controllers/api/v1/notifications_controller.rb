# frozen_string_literal: true

module Api
  module V1
 
    class NotificationsController < ApplicationController
      def broadcast
        type = params[:type] || "sistema"
        title = params[:title] || "Notificação"
        message = params[:message]
        data = params[:data] || {}
        device_types = params[:device_types] 

        if message.blank?
          render json: { error: "Mensagem é obrigatória" }, status: :unprocessable_entity
          return
        end

        if device_types.present? && device_types.is_a?(Array)
          NotificationsService.broadcast_to_devices(
            device_types: device_types,
            type: type.to_sym,
            title: title,
            message: message,
            data: data
          )

          render json: {
            success: true,
            message: "Notificação enviada para dispositivos específicos",
            target_devices: device_types,
            notification: {
              type: type,
              title: title,
              message: message,
              data: data,
              timestamp: Time.current.iso8601
            }
          }, status: :ok
        else

          NotificationsService.broadcast_custom(
            type: type,
            title: title,
            message: message,
            data: data
          )

          render json: {
            success: true,
            message: "Notificação enviada para todos os dispositivos",
            notification: {
              type: type,
              title: title,
              message: message,
              data: data,
              timestamp: Time.current.iso8601
            }
          }, status: :ok
        end
      end

      # POST /api/v1/notifications/sistema
      # Envia uma notificação de sistema
      def sistema
        message = params[:message]
        level = params[:level] || "info"
        data = params[:data] || {}

        if message.blank?
          render json: { error: "Mensagem é obrigatória" }, status: :unprocessable_entity
          return
        end

        unless %w[info warning error].include?(level)
          render json: { error: "Level deve ser: info, warning ou error" }, status: :unprocessable_entity
          return
        end

        NotificationsService.broadcast_sistema(
          message: message,
          level: level,
          data: data
        )

        render json: {
          success: true,
          message: "Notificação de sistema enviada",
          notification: {
            type: "sistema",
            message: message,
            level: level,
            data: data,
            timestamp: Time.current.iso8601
          }
        }, status: :ok
      end

      # GET /api/v1/notifications/status
      def status
        render json: {
          action_cable: {
            status: "active",
            adapter: Rails.application.config.action_cable.adapter || "async",
            url: Rails.application.config.action_cable.url,
            allowed_origins: Rails.application.config.action_cable.allowed_request_origins
          },
          channels: {
            available: [ "NotificationsChannel" ],
            description: "Canal de notificações em tempo real"
          },
          notification_types: NotificationsService::NOTIFICATION_TYPES,
          endpoints: {
            websocket: "ws://localhost:4000/cable",
            broadcast: "/api/v1/notifications/broadcast",
            sistema: "/api/v1/notifications/sistema",
            status: "/api/v1/notifications/status"
          },
          timestamp: Time.current.iso8601
        }, status: :ok
      end

      # POST /api/v1/notifications/test
      # Envia uma notificação de teste
      def test
        test_data = {
          type: "test",
          title: "Notificação de Teste",
          message: "Esta é uma notificação de teste do sistema SISP360",
          data: {
            test: true,
            server_time: Time.current.iso8601
          },
          timestamp: Time.current.iso8601
        }

        ActionCable.server.broadcast("notifications", test_data)

        render json: {
          success: true,
          message: "Notificação de teste enviada",
          notification: test_data
        }, status: :ok
      end
    end
  end
end
