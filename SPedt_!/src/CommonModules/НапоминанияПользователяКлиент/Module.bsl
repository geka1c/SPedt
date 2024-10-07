#Область ПрограммныйИнтерфейс

// Запускает периодическую проверку текущих напоминаний пользователя.
Процедура Включить() Экспорт
	ПроверитьТекущиеНапоминания();
КонецПроцедуры

// Отключает периодическую проверку текущих напоминаний пользователя.
Процедура Выключить() Экспорт
	ОтключитьОбработчикОжидания("ПроверитьТекущиеНапоминания");
КонецПроцедуры

// Создает новое напоминание на указанное время.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Время - Дата - дата и время напоминания;
//  Предмет - ЛюбаяСсылка - предмет напоминания.
//
Процедура НапомнитьВУказанноеВремя(Текст, Время, Предмет = Неопределено) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминание(
		Текст, Время, , Предмет);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает новое напоминание на время, рассчитанное относительно времени в предмете.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Интервал - Число - время в секундах, за которое необходимо напомнить относительно даты в реквизите предмета;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  ИмяРеквизита - Строка - имя реквизита предмета, относительно которого устанавливается срок напоминания.
Процедура НапомнитьДоВремениПредмета(Текст, Интервал, Предмет, ИмяРеквизита) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминаниеДоВремениПредмета(
		Текст, Интервал, Предмет, ИмяРеквизита, Ложь);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает напоминание с произвольным временем или расписанием выполнения.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  ВремяСобытия - Дата - дата и время события, о котором надо напомнить;
//               - РасписаниеРегламентногоЗадания - расписание периодического события.
//               - Строка - имя реквизита Предмета, в котором содержится время наступления события.
//  ИнтервалДоСобытия - Число - время в секундах, за которое необходимо напомнить относительно времени события;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  Идентификатор - Строка - уточняет предмет напоминания, например, "ДеньРождения".
//
Процедура Напомнить(Текст, ВремяСобытия, ИнтервалДоСобытия = 0, Предмет = Неопределено, Идентификатор = Неопределено) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминание(
		Текст, ВремяСобытия, ИнтервалДоСобытия, Предмет, Идентификатор);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает ежегодное напоминание на дату предмета.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Интервал - Число - время в секундах, за которое необходимо напомнить относительно даты в реквизите предмета;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  ИмяРеквизита - Строка - имя реквизита предмета, относительно которого устанавливается срок напоминания.
//
Процедура НапомнитьОЕжегодномСобытииПредмета(Текст, Интервал, Предмет, ИмяРеквизита) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминаниеДоВремениПредмета(
		Текст, Интервал, Предмет, ИмяРеквизита, Истина);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.НастройкиНапоминаний.ИспользоватьНапоминания Тогда
		ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", 60, Истина); // Через 60 секунд после запуска клиента.
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Сбрасывает таймер проверки текущих напоминаний и выполняет проверку немедленно.
Процедура СброситьТаймерПроверкиТекущихОповещений() Экспорт
	ОтключитьОбработчикОжидания("ПроверитьТекущиеНапоминания");
	ПроверитьТекущиеНапоминания();
КонецПроцедуры

// Открывает форму оповещения
Процедура ОткрытьФормуОповещения() Экспорт
	// Хранение формы в переменной требуется для предотвращения открытия дублей формы,
	// а также для уменьшения количества серверных вызовов.
	ИмяПараметра = "СтандартныеПодсистемы.ФормаОповещения";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ИмяФормыОповещения = "РегистрСведений.НапоминанияПользователя.Форма.ФормаОповещения";
		ПараметрыПриложения.Вставить(ИмяПараметра, ПолучитьФорму(ИмяФормыОповещения));
	КонецЕсли;
	ФормаОповещения = ПараметрыПриложения[ИмяПараметра];
	ФормаОповещения.Открыть();
КонецПроцедуры

// Возвращает кэшированные оповещения текущего пользователя, исключив из результата ненаступившие оповещения.
//
// Параметры:
//  ВремяБлижайшего - Дата - в этот параметр возвращается время ближайшего будущего напоминания. Если
//                           ближайшее напоминание за пределами выборки кэша, то возвращается Неопределено.
Функция ПолучитьТекущиеОповещения(ВремяБлижайшего = Неопределено) Экспорт
	
	ТаблицаОповещений = НапоминанияПользователяКлиентПовтИсп.ПолучитьНапоминанияТекущегоПользователя();
	Результат = Новый Массив;
	
	ВремяБлижайшего = Неопределено;
	
	Для Каждого Оповещение Из ТаблицаОповещений Цикл
		Если Оповещение.СрокНапоминания <= ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
			Результат.Добавить(Оповещение);
		Иначе                                                           
			Если ВремяБлижайшего = Неопределено Тогда
				ВремяБлижайшего = Оповещение.СрокНапоминания;
			Иначе
				ВремяБлижайшего = Мин(ВремяБлижайшего, Оповещение.СрокНапоминания);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;		
	
	Возврат Результат;
	
КонецФункции

// Обновляет запись в кэше результата выполнения функции ПолучитьНапоминанияТекущегоПользователя().
Процедура ОбновитьЗаписьВКэшеОповещений(ПараметрыОповещения) Экспорт
	КэшОповещений = НапоминанияПользователяКлиентПовтИсп.ПолучитьНапоминанияТекущегоПользователя();
	Запись = НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения);
	Если Запись <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Запись, ПараметрыОповещения);
	Иначе
		КэшОповещений.Добавить(ПараметрыОповещения);
	КонецЕсли;
КонецПроцедуры

// Удаляет запись из кэша результата выполнения функции ПолучитьНапоминанияТекущегоПользователя().
Процедура УдалитьЗаписьИзКэшаОповещений(ПараметрыОповещения) Экспорт
	КэшОповещений = НапоминанияПользователяКлиентПовтИсп.ПолучитьНапоминанияТекущегоПользователя();
	Запись = НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения);
	Если Запись <> Неопределено Тогда
		КэшОповещений.Удалить(КэшОповещений.Найти(Запись));
	КонецЕсли;
КонецПроцедуры

// Возвращает запись из кэша результата выполнения функции ПолучитьНапоминанияТекущегоПользователя().
Функция НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения)
	Для Каждого Запись Из КэшОповещений Цикл
		Если Запись.Источник = ПараметрыОповещения.Источник
		   И Запись.ВремяСобытия = ПараметрыОповещения.ВремяСобытия Тогда
			Возврат Запись;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

#КонецОбласти
