#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Взаимодействия

// Процедура формирует строки списка участников.
//
// Параметры:
//  Контакты  - Массив - массив, содержащий участников взаимодействия.
//
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Взаимодействия.ЗаполнитьКонтактыДляВстречи(Контакты, Участники);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Взаимодействия

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ВзаимодействияПереопределяемый.ПриЗаполненииНаборовЗначенийДоступа(ЭтотОбъект, Таблица);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Взаимодействия.СформироватьСписокУчастников(ЭтотОбъект);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПриЗаписиДокумента(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли