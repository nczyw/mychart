#include "qcustomplot.h"

class Q_DECL_EXPORT MyChart : public QCustomPlot
{
    Q_OBJECT
public:
    explicit MyChart(QWidget *parent = nullptr);
};
