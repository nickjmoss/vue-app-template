import { FastifyRequest, FastifyReply } from 'fastify';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function getExamples(_: FastifyRequest, reply: FastifyReply) {
    const examples = await prisma.example.findMany();
    reply.send(examples[0].name);
}
