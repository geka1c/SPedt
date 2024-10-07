
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	#Область ПравильноеПроведение
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ПеремещениеВозврата.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	
	
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Обмен100СПрн_Ошибки", ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("НеВыгруженноНаСайт", 	ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Возвраты", 			ДополнительныеСвойства, Движения, Отказ);

	
//	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен(ДополнительныеСвойства, Движения, Отказ);
	
//	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен_РН(ДополнительныеСвойства, Движения, Отказ);
	//СП_ДвиженияСервер.ОтразитьНеВыгруженноНаСайт(ДополнительныеСвойства, Движения, Отказ);
	//СтоСПОбмен_Общий.ОтразитьСтоСПОбмен_РН_Ошибки(ДополнительныеСвойства, Движения, Отказ);	
	//СП_ДвиженияСервер.ОтразитьЗаказыВПосылках(ДополнительныеСвойства, Движения, Отказ);
	
	//Если Константы.НовоеХранениеОстатков.Получить() Тогда
	//	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ОстаткиНаСкладе", ДополнительныеСвойства, Движения, Отказ);
	//КонецЕсли;	
	//
	//СП_ДвиженияСервер.ОтразитьОстаткиТоваров(ДополнительныеСвойства, Движения, Отказ);
	//СП_ДвиженияСервер.ОтразитьПриход(ДополнительныеСвойства, Движения, Отказ);
	//СП_ДвиженияСервер.ОтразитьТранзит(ДополнительныеСвойства, Движения, Отказ);
	////СП_ДвиженияСервер.ОтразитьКПолучению(ДополнительныеСвойства, Движения, Отказ);	
	//СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ШтрафныеЗаказы", ДополнительныеСвойства, Движения, Отказ);
	#КонецОбласти

	
	
	
	
	
	//Движения.Возвраты.Записывать = Истина;
	//Для Каждого ТекСтрокаПокупки Из Покупки Цикл
	//	Движение 				= Движения.Возвраты.Добавить();
	//	Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
	//	Движение.Период 		= Дата;
	//	Движение.Организатор 	= ТекСтрокаПокупки.Организатор;
	//	Движение.Участник 		= ТекСтрокаПокупки.Участник;
	//	Движение.Покупка 		= ТекСтрокаПокупки.Покупка;
	//	Движение.Количество 	= ТекСтрокаПокупки.Количество;
	//	Движение.МестоХранения 	= ТекСтрокаПокупки.МестоХранения;

	//	Движение.Партия 		= ТекСтрокаПокупки.Партия;
	//КонецЦикла;

КонецПроцедуры



Функция   	ВыгрузитьНаСайт() Экспорт
	СтоСПОбмен_Посылки_returnsTransfers.Выгрузить(ЭтотОбъект);
КонецФункции
