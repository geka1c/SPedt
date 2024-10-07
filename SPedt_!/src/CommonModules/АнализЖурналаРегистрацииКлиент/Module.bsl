#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Клиентские события формы отчета.

// Обработчик расшифровки табличного документа формы отчета.
//
// Параметры:
//   ФормаОтчета - УправляемаяФорма - Форма отчета.
//   Элемент     - ПолеФормы        - Табличный документ.
//   Расшифровка          - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "Расширение поля формы для поля табличного документа.ОбработкаРасшифровки" в синтакс-помощнике.
//
Процедура ФормаОтчетаОбработкаРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	Если Расшифровка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя <> "Отчет.АнализЖурналаРегистрации" Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Элемент.ТекущаяОбласть) = Тип("РисунокТабличногоДокумента") Тогда
		Если ТипЗнч(Элемент.ТекущаяОбласть.Объект) = Тип("Диаграмма") Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрВариантОтчета = ОтчетыКлиентСервер.НайтиПараметр(
		ФормаОтчета.Отчет.КомпоновщикНастроек.Настройки,
		ФормаОтчета.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки,
		"ВариантОтчета");
	Если ПараметрВариантОтчета = Неопределено Или ПараметрВариантОтчета.Значение <> "ДиаграммаГанта" Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ТипРасшифровки = Расшифровка.Получить(0);
	Если ТипРасшифровки = "РасшифровкаРегламентногоЗадания" Тогда
		
		ВариантРасшифровки = Новый СписокЗначений;
		ВариантРасшифровки.Добавить("СведенияОРегламентномЗадании", НСтр("ru = 'Сведения о регламентном задании'"));
		ВариантРасшифровки.Добавить("ОткрытьЖурналРегистрации", НСтр("ru = 'Перейти к журналу регистрации'"));
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Расшифровка", Расшифровка);
		ПараметрыОбработчика.Вставить("ФормаОтчета", ФормаОтчета);
		Обработчик = Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение", ЭтотОбъект, ПараметрыОбработчика);
		ФормаОтчета.ПоказатьВыборИзМеню(Обработчик, ВариантРасшифровки);
		
	ИначеЕсли ТипРасшифровки <> Неопределено Тогда
		ПоказатьСведенияОРегламентномЗадании(Расшифровка);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик дополнительной расшифровки (меню табличного документа формы отчета).
//
// Параметры:
//   ФормаОтчета - УправляемаяФорма - Форма отчета.
//   Элемент     - ПолеФормы        - Табличный документ.
//   Расшифровка          - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "Расширение поля формы для поля табличного документа.ОбработкаДополнительнойРасшифровки" в синтакс-помощнике.
//
Процедура ФормаОтчетаОбработкаДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя <> "Отчет.АнализЖурналаРегистрации" Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(Элемент.ТекущаяОбласть) = Тип("РисунокТабличногоДокумента") Тогда
		Если ТипЗнч(Элемент.ТекущаяОбласть.Объект) = Тип("Диаграмма") Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РезультатОбработкаРасшифровкиЗавершение(ВыбранныйВариант, ПараметрыОбработчика) Экспорт
	Если ВыбранныйВариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Действие = ВыбранныйВариант.Значение;
	Если Действие = "СведенияОРегламентномЗадании" Тогда
		
		СписокТочек = ПараметрыОбработчика.ФормаОтчета.ОтчетТабличныйДокумент.Области.ДиаграммаГанта.Объект.Точки;
		Для Каждого ТочкаДиаграммыГанта Из СписокТочек Цикл
			
			РасшифровкаТочки = ТочкаДиаграммыГанта.Расшифровка;
			Если ТочкаДиаграммыГанта.Значение = НСтр("ru = 'Фоновые задания'") Тогда
				Продолжить;
			КонецЕсли;
			
			Если РасшифровкаТочки.Найти(ПараметрыОбработчика.Расшифровка.Получить(2)) <> Неопределено Тогда
				ПоказатьСведенияОРегламентномЗадании(РасшифровкаТочки);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли Действие = "ОткрытьЖурналРегистрации" Тогда
		
		СеансРегламентногоЗадания = Новый СписокЗначений;
		СеансРегламентногоЗадания.Добавить(ПараметрыОбработчика.Расшифровка.Получить(1));
		ДатаНачала = ПараметрыОбработчика.Расшифровка.Получить(3);
		ДатаОкончания = ПараметрыОбработчика.Расшифровка.Получить(4);
		ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", 
			СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьСведенияОРегламентномЗадании(Расшифровка)
	ПараметрыФормы = Новый Структура("РасшифровкаИзОтчета", Расшифровка);
	ОткрытьФорму("Отчет.АнализЖурналаРегистрации.Форма.СведенияОРегламентномЗадании", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти