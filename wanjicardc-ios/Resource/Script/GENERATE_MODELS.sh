#!/bin/sh

#  generateModels.sh
#  LESports
#
#  Created by ZhangQibin on 15/5/12.
#  Copyright (c) 2015年 LETV. All rights reserved.

MODELS_DIR="${PROJECT_DIR}/Classes/Services/DatabaseService/Coredata"
DATA_MODEL_PACKAGE="${MODELS_DIR}/Models/NewCache.xcdatamodeld/NewCache.xcdatamodel"

MACHINE_MODEL_DIR="${MODELS_DIR}/Models/_GENERATED/"
HUMANREAD_MODEL_DIR="${MODELS_DIR}/Models/"
USING_SWIFT=false

if [ -x /usr/local/bin/mogenerator ]; then
echo "mogenerator exists in /usr/local/bin path";
MOGENERATOR_DIR="/usr/local/bin";
elif [ -x /usr/bin/mogenerator ]; then
echo "mogenerator exists in /usr/bin path";
MOGENERATOR_DIR="/usr/bin";
else
echo "mogenerator not found"; exit 1;
fi

echo "start to generate coredata models..."
pwd

${MOGENERATOR_DIR}/mogenerator --v2 --model "${DATA_MODEL_PACKAGE}" --machine-dir "${MACHINE_MODEL_DIR}" --human-dir "${HUMANREAD_MODEL_DIR}" --template-var arc=true #-includeh "${HUMANREAD_MODEL_DIR}/DataModels.h"

if [ ${USING_SWIFT} == false ]; then
${MOGENERATOR_DIR}/mogenerator --v2 --model "${DATA_MODEL_PACKAGE}" --machine-dir "${MACHINE_MODEL_DIR}" --human-dir "${HUMANREAD_MODEL_DIR}" --template-var arc=true #-includeh "${HUMANREAD_MODEL_DIR}/DataModels.h"
else
${MOGENERATOR_DIR}/mogenerator --v2 --model "${DATA_MODEL_PACKAGE}" --machine-dir "${MACHINE_MODEL_DIR}" --human-dir "${HUMANREAD_MODEL_DIR}" --swift --template-var arc=true
fi
