&НаСервере
Функция ПровестиДокумент(ПараметрКоманды)
	
	ДокументОбъект = ПараметрКоманды.ПолучитьОбъект();
	Попытка
		Если НЕ ДокументОбъект.ПроверитьЗаполнение() Тогда 
			Возврат Ложь;
		КонецЕсли;
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;

КонецФункции

&НаСервере
Функция ПолучитьПараметрыДокумента(Ссылка)
	
	МетаданныеДокумента	= Ссылка.Метаданные();
	
	ЕстьРучнаяКорректировка	= ОбщегоНазначения.ЕстьРеквизитОбъекта("РучнаяКорректировка", МетаданныеДокумента);
	
	ИменаРеквизитов	= "Проведен, ПометкаУдаления";
	Если ЕстьРучнаяКорректировка Тогда
		ИменаРеквизитов	= ИменаРеквизитов + ", РучнаяКорректировка";
	КонецЕсли;
	
	Результат	= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов);
	Если НЕ ЕстьРучнаяКорректировка Тогда
		Результат.Вставить("РучнаяКорректировка", Ложь);
	КонецЕсли;
	
	Результат.Вставить("РегОперация",	Ложь);
	Результат.Вставить("ОперацияБух",	Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыДокумента = ПолучитьПараметрыДокумента(ПараметрКоманды);
	
	Если НЕ ПараметрыДокумента.ПометкаУдаления И НЕ ПараметрыДокумента.ОперацияБух И
		НЕ ПараметрыДокумента.РегОперация И НЕ ПараметрыДокумента.РучнаяКорректировка И
		НЕ ПараметрыДокумента.Проведен Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Вставить(0, КодВозвратаДиалога.Да, "Провести");
		Кнопки.Вставить(1, КодВозвратаДиалога.Отмена, "Отмена");
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПараметрыВыполненияКоманды", ПараметрыВыполненияКоманды);
		ДополнительныеПараметры.Вставить("ПараметрКоманды", ПараметрКоманды);
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередПросмотромСледуетПровестиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перед просмотром проводок документ следует провести'"), Кнопки,, КодВозвратаДиалога.Да);
	Иначе
		ПараметрыФормы = Новый Структура("ДокументДвижений", ПараметрКоманды);
		ОткрытьФорму("Обработка.КорректировкаДвижений.Форма", 
			ПараметрыФормы, 
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередПросмотромСледуетПровестиЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = ДополнительныеПараметры.ПараметрКоманды;
	ПараметрыВыполненияКоманды = ДополнительныеПараметры.ПараметрыВыполненияКоманды;
	
	ДокументПроведен = ПровестиДокумент(ПараметрКоманды);
	Если ДокументПроведен Тогда
		ОповеститьОбИзменении(ПараметрКоманды);
		Оповестить("ВыполненаЗаписьДокумента", Новый Структура("ДокументСсылка", ПараметрКоманды));
	Иначе
		Сообщить(НСтр("ru = 'Не удалось провести документ'"), СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ДокументДвижений", ПараметрКоманды);
	ОткрытьФорму("Обработка.КорректировкаДвижений.Форма", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрКоманды);

КонецПроцедуры	
