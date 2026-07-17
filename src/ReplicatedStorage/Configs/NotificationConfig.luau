export type NotificationConfigProperties = {
  Title: string?,
  MessageTemplate: string,
  Duration: number,
  NotificationLayer: "Gameplay" | "Global"
}

export type NotificationPayload = {
  ConfigId: string,
  ContextData: { [string]: string | number }?
}
