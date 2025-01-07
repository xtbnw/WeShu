export class ReminderItemModel {
  id: number;
  content: string;
  isCompleted: boolean;
  remindDateTime: string;
  repeatType: string;

  constructor(id: number, content: string, isCompleted: boolean, remindDateTime: string, repeatType: string) {
    this.id = id;
    this.content = content;
    this.isCompleted = isCompleted;
    this.remindDateTime = remindDateTime;
    this.repeatType = repeatType;
  }
}