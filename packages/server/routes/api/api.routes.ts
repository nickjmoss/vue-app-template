import {
    FastifyInstance,
    FastifyPluginOptions,
    FastifyRegisterOptions,
} from 'fastify';
import { getExamples } from '@controllers/exampleController';

export const apiRoutes = function (
    fastify: FastifyInstance,
    _: FastifyRegisterOptions<FastifyPluginOptions>,
    next: () => void,
) {
    fastify.get('/ping', getExamples);

    next();
};
