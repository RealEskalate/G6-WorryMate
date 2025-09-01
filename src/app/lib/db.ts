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


export class WorryMateDB extends Dexie {
  journals!: Table<JournalEntry, number>; 
  dailyemoji!:Table<DailyEmoji,string>;
  constructor() {
    super("WorryMateDB");
    this.version(2).stores({
      journals: "++id, title, content, date",
      dailyemoji:"date, emoji",
    });
  }
}


export const db = new WorryMateDB();
