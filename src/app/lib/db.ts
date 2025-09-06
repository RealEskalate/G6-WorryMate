import Dexie, { Table } from "dexie";

export interface JournalEntry {
  id?: number;
  title: string;
  content: string;
  date: string;
}
export interface DailyEmoji {
  date: string; 
  emoji: string;
}

export interface CheckIn{
  date:string;
}
export interface ChatMessage {
  id?: number;
  role?: string;
  content: string;
  timestamp: number; 
}
type LocalMessage = { role: 'user' | 'assistant', content: string }


export class WorryMateDB extends Dexie {
  journals!: Table<JournalEntry, number>; 
  dailyemoji!:Table<DailyEmoji,string>;
  checkin!:Table<CheckIn,string>;
  chat!: Table<ChatMessage, number>;

  constructor() {
    super("WorryMateDB");
    this.version(4).stores({
      journals: "++id, title, content, date",
      dailyemoji:"date, emoji",
      checkin:"date",
      chat: "++id, timestamp"
    });
  }
}


export const db = new WorryMateDB();
