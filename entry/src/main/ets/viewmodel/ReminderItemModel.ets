export class ReminderItemModel {
  id: number;
  content: string;
  isCompleted: boolean;
  remindDateTime?: string;
  repeatType?: string;

  constructor(id: number, content: string, isCompleted: boolean, remindDateTime?: string, repeatType?: string) {
    this.id = id;
    this.content = content;
    this.isCompleted = isCompleted;
    if (remindDateTime) {
      this.remindDateTime = remindDateTime;
    }
    if (repeatType) {
      this.repeatType = repeatType;
    }
  }
}